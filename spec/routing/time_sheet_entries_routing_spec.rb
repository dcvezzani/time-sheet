require "spec_helper"

describe TimeSheetEntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/time_sheet_entries").should route_to("time_sheet_entries#index")
    end

    it "routes to #new" do
      get("/time_sheet_entries/new").should route_to("time_sheet_entries#new")
    end

    it "routes to #show" do
      get("/time_sheet_entries/1").should route_to("time_sheet_entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/time_sheet_entries/1/edit").should route_to("time_sheet_entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/time_sheet_entries").should route_to("time_sheet_entries#create")
    end

    it "routes to #update" do
      put("/time_sheet_entries/1").should route_to("time_sheet_entries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/time_sheet_entries/1").should route_to("time_sheet_entries#destroy", :id => "1")
    end

  end
end
