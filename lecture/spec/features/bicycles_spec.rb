require 'rails_helper'
require 'support/database_cleaner'

RSpec.feature "Bicycles", type: :feature, js: true do

  before :each do
    @brand = FactoryBot.create(:brand, name: 'Brand', country: 'Canada')
    @hildebrand = FactoryBot.create(:brand, name: 'Hildebrand', country: 'USA')
    @exterminator = FactoryBot.create(:brand, name: 'Exterminator', country: 'USA')

    @fixie = FactoryBot.create(:style, name: 'Fixie')
    @hybrid = FactoryBot.create(:style, name: 'Hybrid')
    @bmx = FactoryBot.create(:style, name: 'BMX')

    @bike1 = FactoryBot.create(:bicycle,
      brand: @brand,
      style: @fixie,
      speeds: 1,
      colour: 'Red',
      model: 'Moustache'
    )
    @bike2 = FactoryBot.create(:bicycle,
      brand: @hildebrand,
      style: @hybrid,
      speeds: 10,
      colour: 'Black',
      model: 'Roadmeister'
    )
    @bike3 = FactoryBot.create(:bicycle,
      brand: @exterminator,
      style: @bmx,
      speeds: 1,
      colour: 'Extreme chrome',
      model: 'DESTROYENATOR'
    )
  end

  scenario "Lists all bikes" do
    visit '/bicycles'
    
    expect(page).to have_css("div.bicycle", count: 3)
    expect(page).to have_text("Red Brand Moustache Fixie", count: 1)
    save_screenshot("bicycles_index.png")
  end

  scenario "Filter all bikes by model" do
    visit "/bicycles"

    fill_in "model", with: @bike1.model
    click_button("Search!")
    save_screenshot("filtered_by_model.png")

    expect(page).to have_css("div.bicycle", count: 1)
    expect(page).to have_text(@bike1.description)
  end

  scenario "Filter all bikes by style" do
    visit bicycles_path

    select @bmx.name, from: "style"
    click_button("Search!")
    save_screenshot("filter_by_style.png")

    expect(page).to have_css("div.bicycle", count: 1)
    expect(page).to have_text(@bike3.description)
  end

  scenario "Filter all bikes by speed" do
    visit bicycles_path

    fill_in "speeds", with: @bike3.speeds
    click_button("Search!")
    save_screenshot("filter_by_speed.png")

    expect(page).to have_css("div.bicycle", count: 2)
    expect(page).to have_text(@bike1.description)
    expect(page).to have_text(@bike3.description)
  end

end
