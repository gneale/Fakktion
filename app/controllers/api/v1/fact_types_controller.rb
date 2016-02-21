# Fact Types Controller: JSON response through Active Model Serializers
class Api::V1::FactTypesController < ApiController
	respond_to :json
	
	def index
		render json: FactType.all
	end

	def show
		render json: factType
	end

	def create
		render json: FactType.create(factType_params)
	end

	def update
		render json: factType.update(factType_params)
	end

	def destroy
		render json: factType.destroy
	end

	private

	def factType
		FactType.find(params[:id])
	end

	def factType_params
		ActiveModel::Serializer::Adapter::JsonApi::Deserialization.parse(params.to_h)
	end
end
