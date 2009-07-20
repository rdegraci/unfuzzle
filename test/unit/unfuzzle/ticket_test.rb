require File.dirname(__FILE__) + '/../../test_helper'

module Unfuzzle
  class TicketTest < Test::Unit::TestCase

    context "The Ticket class" do

      should "be able to return a list of tickets for a project" do
        project_id = 1

        response = mock_request_cycle :for => "/projects/#{project_id}/tickets", :data => 'tickets'

        Unfuzzle::Ticket.expects(:collection_from).with(response.body, 'tickets/ticket').returns(['ticket_1', 'ticket_2'])

        Ticket.find_all_by_project_id(project_id).should == ['ticket_1', 'ticket_2']
      end

      should "be able to return a list of tickets for a milestone" do
        milestone_id = 1
        project_id   = 1

        response = mock_request_cycle :for => "/projects/#{project_id}/milestones/#{milestone_id}/tickets", :data => 'tickets'

        Unfuzzle::Ticket.expects(:collection_from).with(response.body, 'tickets/ticket').returns(['ticket_1', 'ticket_2'])
        
        Ticket.find_all_by_project_id_and_milestone_id(project_id, milestone_id).should == ['ticket_1', 'ticket_2']
      end

    end

    context "An instance of the Ticket class" do

      when_populating Ticket, :from => 'ticket' do

        value_for :id,                :is => 1
        value_for :project_id,        :is => 1
        value_for :milestone_id,      :is => 1
        value_for :created_timestamp, :is => '2008-11-25T14:00:19Z'
        value_for :updated_timestamp, :is => '2008-12-31T15:51:41Z'
        value_for :number,            :is => '1'
        value_for :title,             :is => 'Ticket #1'
        value_for :description,       :is => 'Do something important'
        value_for :due_datestamp,     :is => nil
        value_for :status,            :is => 'closed'

      end
      
      should_set_a_value_for :title
      should_set_a_value_for :description
      
      context "with a new instance" do
        setup { @ticket = Ticket.new }

        should "have a create date/time" do
          DateTime.expects(:parse).with('2008-07-28T16:57:10Z').returns('create_date')

          @ticket.stubs(:created_timestamp).with().returns('2008-07-28T16:57:10Z')
          @ticket.created_at.should == 'create_date'
        end

        should "have an update date/time" do
          DateTime.expects(:parse).with('2009-04-28T18:48:52Z').returns('update_date')

          @ticket.stubs(:updated_timestamp).with().returns('2009-04-28T18:48:52Z')
          @ticket.updated_at.should == 'update_date'
        end

        should "have a due date" do
          Date.expects(:parse).with('2008-07-30').returns('due_date')

          @ticket.stubs(:due_datestamp).with().returns('2008-07-30')
          @ticket.due_on.should == 'due_date'
        end

        should "not have a due date if there isn't one associated" do
          @ticket.stubs(:due_datestamp).with().returns(nil)
          @ticket.due_on.should be(nil)
        end
        
        should "have an associated milestone" do
          Milestone.expects(:find_by_project_id_and_milestone_id).with(1, 2).returns('milestone')
          
          @ticket.stubs(:project_id).with().returns(1)
          @ticket.stubs(:milestone_id).with().returns(2)
          
          @ticket.milestone.should == 'milestone'
        end
        
        should "be able to generate a hash representation of itself for updating" do
          @ticket.id           = 1
          @ticket.project_id   = 2
          @ticket.milestone_id = 3
          @ticket.number       = '12'
          @ticket.title        = 'summary'
          @ticket.description  = 'description'
          @ticket.status       = 'closed'

          
          expected = {
            'id'           => 1,
            'project_id'   => 2,
            'milestone_id' => 3,
            'number'       => '12',
            'summary'      => 'summary',
            'description'  => 'description',
            'status'       => 'closed'
          }
          
          @ticket.to_hash.should == expected          
        end
        
        should "be able to perform an update" do
          @ticket.stubs(:project_id).with().returns(1)
          @ticket.stubs(:id).with().returns(2)
          
          resource_path = '/projects/1/tickets/2'
          ticket_xml    = '<ticket />'
          
          @ticket.stubs(:to_xml).with('ticket').returns(ticket_xml)
          
          Unfuzzle::Request.expects(:put).with(resource_path, ticket_xml).returns('response')
          
          @ticket.update.should == 'response'
        end

      end

    end

  end
end
