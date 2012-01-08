# Ruby wrapper around the Trello API
# Copyright (c) 2012, Jeremy Tregunna
# Use and distribution terms may be found in the file LICENSE included in this distribution.

module Trello
  class Card < BasicData
    class << self
      def find(id)
        super(:cards, id)
      end
    end

    # Fields

    def id
      fields['id']
    end

    def name
      fields['name']
    end

    def description
      fields['desc']
    end

    def closed
      fields['closed']
    end

    def url
      fields['url']
    end

    # Links to other data structures

    def actions
      response = Client.query("/1/cards/#{id}/actions")
      JSON.parse(response.read_body).map do |action_fields|
        Action.new(action_fields)
      end
    end

    def board
      Board.find(fields['idBoard'])
    end

    def checklists
      response = Client.query("/1/cards/#{id}/checklists")
      JSON.parse(response.read_body).map do |checklist_fields|
        Checklist.new(checklist_fields)
      end
    end

    def list
      List.find(fields['idList'])
    end

    def members
      fields['idMembers'].map do |member_id|
        response = Client.query("/1/members/#{member_id}")
        Member.new(JSON.parse(response.read_body))
      end
    end

    # Add a comment
    def comment(text)
      response = Client.query("/1/cards/#{id}/actions/comments", :method => :put, :params => { :text => text })
    end
  end
end