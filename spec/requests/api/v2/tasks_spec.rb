require 'swagger_helper'

RSpec.describe 'api/v2/tasks', type: :request, swagger_doc: 'v2/swagger.yaml' do
  path '/api/v2/tasks' do

    post('create task') do
      tags 'Tasks'
      description 'Create task'
      consumes "application/json"

      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          assignee_id: { type: :integer, default: 1 },
          column_id: { type: :integer, default: 1 },
          desk_id: { type: :integer, default: 1 },
          project_id: { type: :integer, default: 1 },
          user_id: { type: :integer, default: 1 },
          name: { type: :string },
          description: { type: :string },
          priority_number: { type: :integer, default: 1 },
          estimate: { type: :string },
          time_work: { type: :string },
          label: { type: :string },
          priority: { type: :integer },
          start_date: { type: :string },
          end_date: { type: :string },
          status: { type: :integer },
          type_of: { type: :integer }
        },
        required: %w[name column_id  desk_id project_id user_id]
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

  path '/api/v2/tasks/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show task') do
      tags 'Tasks'
      description 'Get task by id'
      consumes "application/json"
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

    patch('update task') do
      tags 'Tasks'
      description 'Update task'
      consumes "application/json"

      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          assignee_id: { type: :integer, default: 1 },
          column_id: { type: :integer, default: 1 },
          desk_id: { type: :integer, default: 1 },
          project_id: { type: :integer, default: 1 },
          user_id: { type: :integer, default: 1 },
          name: { type: :string },
          description: { type: :string },
          priority_number: { type: :integer, default: 1 },
          estimate: { type: :string },
          time_work: { type: :string },
          label: { type: :string },
          priority: { type: :integer },
          start_date: { type: :string },
          end_date: { type: :string },
          status: { type: :integer },
          type_of: { type: :integer }
        },
        required: %w[name column_id desk_id project_id user_id]
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

    delete('delete task') do
      tags 'Tasks'
      description 'Delete task'
      consumes "application/json"
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
  end
end
