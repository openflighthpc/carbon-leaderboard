class Boavizta
  require 'faraday'
  BOAVIZTA_URL='https://api.boavizta.openflighthpc.org'
  PROVIDERS={'AWS' => 'aws',
             'Alces Cloud' => 'alces'}

  def self.boavizta
    @boavizta ||= Faraday.new(BOAVIZTA_URL)
  end

  def self.carbon_for_load(device, cpu_load)
    if device.instance_type.blank?
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
      response = boavizta.post('/v1/cloud/instance') do |req|
        req.headers[:content_type] = 'application/json'
        req.params[:verbose] = false
        req.params['criteria'] = 'gwp'
        req.params['duration'] = 1
        req.body = JSON.pretty_generate(
          {
            "provider": device.cloud_provider,
            "instance_type": device.instance_type,
            "usage": {
              "usage_location": device.location,
              "time_workload": [
                {
                  "time_percentage": 100,
                  "load_percentage": cpu_load
                }
              ]
            }
          }
        )
      end
    end
    JSON.parse(response.body).dig(*%w[impacts gwp use value]) * 1000
  end

  def self.provider(platform)
    PROVIDERS[platform]
  end

  def self.type_exists?(type, provider)
    response = boavizta.get('/v1/cloud/instance/all_instances') do |req|
      req.params[:provider] = provider
    end
    JSON.parse(response.body).include?(type)
  end
end
