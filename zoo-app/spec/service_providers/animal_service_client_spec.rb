require_relative 'pact_helper'
require 'zoo_app/animal_service_client'

module ZooApp
  describe AnimalServiceClient, :pact => true do

    before do
      AnimalServiceClient.base_uri animal_service.mock_service_base_url
    end

    describe ".find_alligator_by_name" do
      context "when an alligator by the given name exists" do

        before do
          animal_service.given("there is an alligator named Mary").
            upon_receiving("a request for an alligator").with(
              method: :get,
              path: '/alligators/Mary',
              headers: {'Accept' => 'application/json'} ).
            will_respond_with(
              status: 200,
              headers: {'Content-Type' => 'application/json;charset=utf-8'},
              body: {name: 'Mary'}
            )
        end

        it "returns the alligator" do
          expect(AnimalServiceClient.find_alligator_by_name("Mary")).to eq ZooApp::Animals::Alligator.new(name: 'Mary')
        end

      end

      context "when an alligator by the given name does not exist" do

        before do
          animal_service.given("there is not an alligator named Mary").
            upon_receiving("a request for an alligator").with(
              method: :get,
              path: '/alligators/Mary',
              headers: {'Accept' => 'application/json'} ).
            will_respond_with(status: 404)
        end

        it "returns nil" do
          expect(AnimalServiceClient.find_alligator_by_name("Mary")).to be_nil
        end

      end

      context "when an error occurs retrieving the alligator" do

        before do
          animal_service.given("an error occurs retrieving an alligator").
            upon_receiving("a request for an alligator").with(
              method: :get,
              path: '/alligators/Mary',
              headers: {'Accept' => 'application/json'}).
            will_respond_with(
              status: 500,
              headers: { 'Content-Type' => 'application/json;charset=utf-8'},
              body: {error: 'Argh!!!'})
        end

        it "raises an error" do
          expect{ AnimalServiceClient.find_alligator_by_name("Mary") }.to raise_error /Argh/
        end

      end
    end

    describe ".find_seahawk_by_name" do
      context "when a seahawk by the given name exists" do

        before do
          animal_service.given("there is a seahawk named Geno").
            upon_receiving("a request for a seahawk").with(
              method: :get,
              path: '/seahawks/Geno',
              headers: {'Accept' => 'application/json'} ).
            will_respond_with(
              status: 200,
              headers: {'Content-Type' => 'application/json;charset=utf-8'},
              body: {name: 'Geno'}
            )
        end

        it "returns the seahawk" do
          expect(AnimalServiceClient.find_seahawk_by_name("Geno")).to eq ZooApp::Animals::Seahawk.new(name: 'Geno')
        end
      end

      context "when a seahawk by the given name does not exist" do

        before do
          animal_service.given("there is not a seahawk named Mary").
            upon_receiving("a request for a seahawk").with(
              method: :get,
              path: '/seahawks/Geno',
              headers: {'Accept' => 'application/json'} ).
            will_respond_with(status: 404)
        end

        it "returns nil" do
          expect(AnimalServiceClient.find_seahawk_by_name("Geno")).to be_nil
        end
      end
    end
  end
end