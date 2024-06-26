class GroupController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def show
    @group = Device.where(group: params[:group_id])
    @year_emissions = (@group.first.max * 8.76).round(2)
    @emission_conversions = {}.tap do |ec|
      ec[:driving] = (@year_emissions * EmissionConversion::DRIVE).floor
      ec[:big_mac] = (@year_emissions * EmissionConversion::BIG_MAC).floor
      ec[:mcplant] = (@year_emissions * EmissionConversion::MCPLANT).floor
      ec[:flight] = (@year_emissions * EmissionConversion::FLIGHT).floor
      ec[:netflix] = (@year_emissions * EmissionConversion::NETFLIX).floor
    end
    @user_devices = @group.pluck(:user_id)
                          .uniq
                          .compact
                          .map do |id|
      [User.find(id).username, @group.where(user_id: id).pluck(:display_name)]
    end
    @anon_devices = @group.where(user_id: nil)
                          .pluck(:display_name)
  end

  def raw_data
    kg = params[:unit] == 'kg_per_year'
    devices = Device.groups_ranked
    response = {}.tap do |res|
      max_device = devices.last
      res[:max_main] = max_device&.max_per_core&. * (kg ? 8.76 : 1)
      res[:header] = {}.tap do |h|
        h[:user] = 'Group'
        h[:platform] = 'Platform'
        h[:location] = 'Location'
        h[:core_number] = 'No. cores'
        h[:ram] = 'RAM (GB)'
        h[:main] = "Carbon emissions per core at full load (CO2eq/#{kg ? 'year' : 'hour'})"
      end
      rank = 1
      res[:groups] = devices
                       .group_by(&:max_per_core)
                       .values.flat_map do |dev_group|
        current_rank = rank
        rank += dev_group.size
        dev_group.map do |dev|
          {}.tap do |new_dev|
            new_dev[:rank] = current_rank
            new_dev[:user] = dev.pretty_group
            new_dev[:platform] = {}.tap do |plat|
              plat[:ico] = dev.platform_icon
              plat[:text] = dev.platform
            end
            new_dev[:location] = {}.tap do |loc|
              loc[:flag] = dev.two_digit_location.downcase
              loc[:text] = dev.location
            end
            new_dev[:core_number] = dev.cpus * dev.cores_per_cpu
            new_dev[:ram] = dev.ram_units * dev.ram_capacity_per_unit
            new_dev[:main] = signif(dev.max_per_core * (kg ? 8.76 : 1), 3)
            new_dev[:unit] = "#{kg ? 'k' : ''}g"
            new_dev[:group_id] = dev.group
          end
        end
      end
    end
    render json: response
  end
end
