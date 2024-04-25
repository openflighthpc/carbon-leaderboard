class Boavizta
  require 'faraday'
  BOAVIZTA_URL="https://api.boavizta.openflighthpc.org"

  def self.boavizta
    @boavizta ||= Faraday.new(BOAVIZTA_URL)
  end

  def self.carbon_for_load(device, cpu_load)
    if device.cloud_provider.blank? || device.instance_type.blank?
      response = boavizta.post('/v1/server/') do |req|
        req.headers[:content_type] = 'application/json'
        req.params[:verbose] = false
        req.params[:criteria] = 'gwp'
        req.body = JSON.pretty_generate(
          {
            "model": {
              "type": "rack"
            },
            "configuration": {
              "cpu": {
                "units": device.cpus,
                "core_units": device.cores_per_cpu,
                "name": device.cpu_name
              },
              "ram": [{
                "units": device.ram_units,
                "capacity": device.ram_capacity_per_unit
              }],
              "disk": device.disks
            },
            "usage": {
              "usage_location": device.location,
              "hours_use_time": 1,
              "hours_life_time": 1,
              "time_workload": cpu_load
            }
          }
        )
      end
    else
      response = boavizta.get('/v1/cloud/instance') do |req|
        req.headers[:content_type] = 'application/json'
        req.params[:provider] = device.cloud_provider
        req.params[:instance_type] = device.instance_type
        req.params[:verbose] = false
        req.params['criteria'] = 'gwp'
        req.params['duration'] = 1
      end
    end
    JSON.parse(response.body).dig(*%w[impacts gwp use value])
  end
end
