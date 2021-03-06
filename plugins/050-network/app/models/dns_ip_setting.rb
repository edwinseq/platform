require 'resolv'

class DnsIpSetting < Setting
  validates :value, presence: true, format: { with: Resolv::IPv4::Regex }

  def self.dns_ips
    case self.get("dns")
    when "opendns"
      self.opendns
    when "google_dns"
      self.google_dns
    else
      self.custom_dns_ips
    end
  end

  def self.opendns
    %w(208.67.222.222 208.67.220.220)
  end

  def self.google_dns
    %w(8.8.8.8 8.8.4.4)
  end

  def self.custom_dns_ips
    [
      self.find_or_create_by(Setting::NETWORK, "dns_ip_1", "208.67.222.222"),
      self.find_or_create_by(Setting::NETWORK, "dns_ip_2", "208.67.220.220"),
    ].map(&:value)
  end
end
