class ServicesController < ApplicationController
  respond_to :html

  def index
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

    respond_with(@service) do |format|
      format.html do
        if @service.save
          redirect_to @service
        else
          render :new
        end
      end
    end
  end

  def update
  end

  def destroy
  end

  def show
  end

  protected

  def becomes(params, service=nil)
    service ||= Service.new
    type = params.fetch(:type, 'immediate')
    service.becomes(type.camelize.constantize)
  end
end
