# Fact Types Controller: JSON response through Active Model Serializers
class Api::V1::FactTypesController < ApiController
  respond_to :json

  # Render all FactTypes using FactTypeSerializer.
  def index
    render json: FactType.order('name ASC').all
  end

  # Render the specified FactType using FactTypeSerializer.
  def show
    render json: factType
  end

  # Render the created FactType using FactTypeSerializer and the AMS Deserialization.
  def create
      json_create(factType_params, FactType)
  end

  # Render the updated FactType using FactTypeSerializer and the AMS Deserialization.
  def update
    json_update(factType,factType_params, FactType)
  end

  # Destroy FactType from the AMS Deserialization params.
  def destroy
    render json: {}, status: :method_not_allowed
  end

  private

  # FactType object from the Deserialization params if there is an id.
  def factType
    FactType.find(params[:id])
  end

  # AMS FactType Deserialization.
  def factType_params
    ActiveModelSerializers::Deserialization.jsonapi_parse!(params.to_unsafe_h)
  end
end
