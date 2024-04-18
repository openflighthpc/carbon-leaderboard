class BezierModel{
    constructor(canvasDom){

        this.canvas = canvasDom;
        const canvasDimensions = this.canvas.getBoundingClientRect();
        this.canvas.width = 450;
        this.canvas.height = 450;
        this.canvasCtx = this.canvas.getContext('2d');
        this.canvasCtx.lineWidth = 72;

        this.colors = [];
        this.colors.push(new BezierColor(176, 219, 255));
        this.colors.push(new BezierColor(172, 255, 226));

        this.sectionSize = 6;
        this.controlPointSize = this.sectionSize * 2;
        this.arrOriginControlControlPoints = BezierModel.generateCoordinates(this.controlPointSize, this.canvas.width, this.canvas.height);
        this.arrTargetControlControlPoints = BezierModel.generateCoordinates(this.controlPointSize, this.canvas.width, this.canvas.height);
        this.arrOriginControlPoints = BezierModel.getMiddlePoints(this.arrOriginControlControlPoints, this.arrTargetControlControlPoints);
        this.arrOriginControlControlPoints = this.arrTargetControlControlPoints;
        this.arrTargetControlControlPoints = BezierModel.generateCoordinates(this.controlPointSize, this.canvas.width, this.canvas.height);
        this.arrTargetControlPoints = BezierModel.getMiddlePoints(this.arrOriginControlControlPoints, this.arrTargetControlControlPoints);
        
        this.controlPointer = 0;
        this.controlSegmentPointer = 0;
        this.controlSegment = 300;

        this.singlePathSegment = 60;

        this.colorPointer = 0;
        this.colorStepPointer = 0;
        this.colorStep = 3;
    }

    static generateCoordinates(intN, intWidth, intHeight){
        let arrCoordinates = [];
        for(let i = 0; i < intN; i++){
            // const x = Math.floor(Math.random() * intWidth);
            // const y = Math.floor(Math.random() * intHeight);
            const x = Math.floor(Math.random() * intWidth * 2 - intWidth / 2);
            const y = Math.floor(Math.random() * intHeight * 2 - intHeight / 2);
            arrCoordinates.push(new BezierCoordinate(x, y));
        }
        return arrCoordinates;
    }

    static getEndPoints(arrControlPoints){
        let arrEndPoints = [];
        for(let i = 0; i < arrControlPoints.length; i += 2){
            const startCoordinate = arrControlPoints[i];
            const endCoordinate = arrControlPoints[i + 1];
            arrEndPoints.push(BezierModel.getMiddlePoint(startCoordinate, endCoordinate));
        }
        return arrEndPoints;
    }
    
    static getMiddlePoint(startCoordinate, endCoordinate){
        const middlePointX = (startCoordinate.x + endCoordinate.x) / 2;
        const middlePointY = (startCoordinate.y + endCoordinate.y) / 2;
        return new BezierCoordinate(middlePointX, middlePointY);
    }

    static getMiddlePoints(startCoordinates, endCoordinates){
        let arrMiddlePoints = [];
        for(let i = 0; i < startCoordinates.length; i++){
            arrMiddlePoints.push(BezierModel.getMiddlePoint(startCoordinates[i], endCoordinates[i]));
        }
        return arrMiddlePoints;
    }

    static getPercentagePoint(startCoordinate, endCoordinate, intPercentage){
        const percentagePointX = (endCoordinate.x - startCoordinate.x) * intPercentage + startCoordinate.x;
        const percentagePointY = (endCoordinate.y - startCoordinate.y) * intPercentage + startCoordinate.y;
        return new BezierCoordinate(percentagePointX, percentagePointY);
    }

    static getPathPoint(arrPathPoints, intPercentage){
        let arrDescendedPathPoints = [];
        for(let i = 0; i < arrPathPoints.length - 1; i++){
            let startCoordinate = arrPathPoints[i];
            let endCoordinate = arrPathPoints[i + 1];
            let descendedPathPoint = BezierModel.getPercentagePoint(startCoordinate, endCoordinate, intPercentage);
            arrDescendedPathPoints.push(descendedPathPoint);
        }
        if(arrDescendedPathPoints.length === 1){
            return arrDescendedPathPoints[0];
        }
        return BezierModel.getPathPoint(arrDescendedPathPoints, intPercentage);
    }

    getNextControlSegmentPoints () {
        let points = [];
        for (let i = 0; i < this.controlPointSize; i++) {
            const startCoordinate = this.arrOriginControlPoints[i % this.controlPointSize];
            const controlCoordinate = this.arrOriginControlControlPoints[i % this.controlPointSize];
            const endCoordinate = this.arrTargetControlPoints[i % this.controlPointSize];
            points.push(BezierModel.getPathPoint([startCoordinate, controlCoordinate, endCoordinate], this.controlSegmentPointer / this.controlSegment));
        }
        if (++this.controlSegmentPointer === this.controlSegment) {
            this.controlSegmentPointer = 0;
            this.arrOriginControlPoints = this.arrTargetControlPoints;
            this.arrOriginControlControlPoints =  this.arrTargetControlControlPoints;
            this.arrTargetControlControlPoints = BezierModel.generateCoordinates(this.controlPointSize, this.canvas.width, this.canvas.height);
            this.arrTargetControlPoints = BezierModel.getMiddlePoints(this.arrOriginControlControlPoints,  this.arrTargetControlControlPoints);

        }

        return points;
    }

    draw(){
        requestAnimationFrame(() => {
            this.canvasCtx.clearRect(0, 0, this.canvas.width, this.canvas.height);

            const controlPoints = this.getNextControlSegmentPoints();
            for (let i = 0; i < this.controlPointSize; i += 2) {
                const controlPoint1 = controlPoints[i];
                const controlPoint2 = controlPoints[(i + 1) % this.controlPointSize];
                const controlPoint3 = controlPoints[(i + 2) % this.controlPointSize];
                const controlPoint4 = controlPoints[(i + 3) % this.controlPointSize];
                const startPoint = BezierModel.getMiddlePoint(controlPoint1, controlPoint2);
                const endPoint = BezierModel.getMiddlePoint(controlPoint3, controlPoint4);
                this.canvasCtx.beginPath();
                this.canvasCtx.moveTo(startPoint.x, startPoint.y);
                this.canvasCtx.bezierCurveTo(
                    controlPoint1.x, controlPoint1.y,
                    controlPoint2.x, controlPoint2.y,
                    endPoint.x, endPoint.y
                );
                this.canvasCtx.strokeStyle = this.colors[this.colorPointer];
                this.canvasCtx.stroke();
                if (++this.colorStepPointer === this.colorStep) {
                    this.colorStepPointer = 0;
                    this.colorPointer = (this.colorPointer + 1) % 2;
                }
            }
            this.draw();
        });
    }
}

class BezierCoordinate{
    constructor(x, y, bezierColor = new BezierColor(0, 0, 0)){
        this.x = Math.round(x);
        this.y = Math.round(y);
        this.setColor(bezierColor);
    }

    /* equals(coordinate){
        return this.x === coordinate.x && this.y === coordinate.y;
    } */
    setColor(bezierColor){
        this.color = bezierColor;
    }
}

class BezierGradient{
    constructor(arrBezierColors){
        this.arrBezierColors = arrBezierColors;
        this.intGradientSize = arrBezierColors.length;
    }

    getPercentageColor(intPercentage){
        let intStartColorIndex = Math.floor(intPercentage * this.intGradientSize) % this.intGradientSize;
        return this.arrBezierColors[intStartColorIndex];
    }
}

class BezierColor{
    constructor(r, g, b){
        this.r = r;
        this.g = g;
        this.b = b;
    }

    toString(){
        return "rgb(" + this.r + ", " + this.g + ", " + this.b + ")";
    }
}

