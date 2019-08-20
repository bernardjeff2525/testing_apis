class DomainNameServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dns, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:update, :edit]
  before_action :dns_new, only: :create
  before_action :clear_prefix, only: [:update, :create]

  def index
    @domain_name_services = DomainNameService.all
    @domain_name_services = @domain_name_services.where(user_id: current_user.id) unless current_user.admin?
    @domain_name_services = @domain_name_services.where(status: params[:status]) if params[:status]
    @domain_name_services = @domain_name_services.page(params[:page]).per(6)
  end

  def new
    @domain_name_service = DomainNameService.new
  end

  def create
    if @domain_name_service.save
      flash[:success] = "Domain Name Service was successfully created"
      redirect_to domain_name_service_path(@domain_name_service)
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @domain_name_service.update(dns_params)
      flash[:success] = "Domain Name Service was successfully updated"
      redirect_to domain_name_service_path(@domain_name_service)
    else
      render "edit"
    end
  end
  private
  def dns_params
    params.require(:domain_name_service).permit(:dns, :https, :status)
  end

  def set_dns
    @domain_name_service = DomainNameService.find(params[:id])
  end

  def dns_new
    @domain_name_service = current_user.domain_name_services.new(dns_params)
  end

  def clear_prefix
    dns = dns_params[:dns]
    dns.delete_prefix! "https://"
    dns.delete_prefix! "http://"
    @domain_name_service.dns = dns
  end

  def require_same_user
    if current_user != @domain_name_service.user and !current_user.admin?
      flash[:danger] = "You can only edit or update your own DNS"
      redirect_to root_path
    end
  end
end
