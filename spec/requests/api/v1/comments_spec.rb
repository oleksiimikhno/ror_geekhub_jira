require 'swagger_helper'

RSpec.describe 'api/v1/comments', type: :request do
  path '/api/v1/projects/{project_id}/comments' do
    parameter name: :project_id, in: :path, type: :integer, description: 'project_id'

    post('create comment') do
      tags 'Comments'
      description 'Create comment'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :сomment, in: :body, schema: {
        type: :object,
        properties: {
          body: { type: :string,  default: 'My comment' },
          commentable_type: { type: :string, default: 'Task' },
          commentable_id: { type: :integer, default: 1 }
        },
        required: %w[body commentable_type commentable_id]
      }
      response(200, 'successful') do

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/projects/{project_id}/comments/{id}' do
    parameter name: :project_id, in: :path, type: :integer, description: 'project_id'
    parameter name: 'id', in: :path, type: :string, description: 'id'

    patch('update comment') do
      tags 'Comments'
      description 'Update comment'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :сomment, in: :body, schema: {
        type: :object,
        properties: {
          body: { type: :string,  default: 'My comment' },
          commentable_type: { type: :string, default: 'Task' },
          commentable_id: { type: :integer, default: 1 }
        },
        required: %w[body commentable_type commentable_id]
      }
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update comment') do
      tags 'Comments'
      description 'Put comment'
      produces 'application/json'
      consumes 'application/json'
      parameter name: :сomment, in: :body, schema: {
        type: :object,
        properties: {
          body: { type: :string,  default: 'My comment' },
          commentable_type: { type: :string, default: 'Task' },
          commentable_id: { type: :integer, default: 1 }
        },
        required: %w[body commentable_type commentable_id]
      }
      response(200, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete comment') do
      tags 'Comments'
      description 'Delete comment'
      consumes "application/json"
      response(204, 'successful') do
        let(:id) { '123' }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
