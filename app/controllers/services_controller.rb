class ServicesController < ApplicationController
  respond_to :html
  before_filter :login_required

  def index
    @services = current_user.services
  end

  def new
    @service = becomes(params)
    respond_with(@service)
  end

  def create
    type = params[:service].delete(:type)
    @service = case type
                 when 'Immediate' then Immediate.new(params[:service])
                 when 'Broadcast' then Broadcast.new(params[:service])
                 when 'Event' then Event.new(params[:service])
                 when 'Subscription' then Subscription.new(params[:service])
                 end
    @service.user = current_user

    respond_with(@service) do |format|
      format.html do
        if @service.save
          redirect_to services_path
        else
          render :new
        end
      end
    end
  end

  def update
    type = params[:service].delete(:type)
    @service = Service.find(params[:id])

    respond_with(@service) do |format|
      format.html do
        if @service.update_attributes(params[:service])
          redirect_to services_path
        else
          render :edit
        end
      end
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy

    redirect_to services_path
  end

  def edit
    @service = Service.find(params[:id])
  end

  protected

  def becomes(params, service=nil)
    service ||= Service.new
    type = params.fetch(:type, 'immediate')
    service.becomes(type.camelize.constantize)
  end

  def login_required
    redirect_to '/sessions/new' unless current_user
  end
end
