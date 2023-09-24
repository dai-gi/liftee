module Admin
  class UsersController < ActiveAdmin::ResourceController
    def create
      super do |format|
        if resource.errors.any?
          puts resource.errors.full_messages
        end
      end
    end
  end
end