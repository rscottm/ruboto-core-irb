#######################################################
#
# demo-ruboto.rb (by Scott Moyer)
# 
# A simple look at how to generate and 
# use a RubotoActivity.
#
#######################################################

require "ruboto.rb"
confirm_ruboto_version(4)

#
# ruboto_import_widgets imports the UI widgets needed
# by the activities in this script. ListView and Button 
# come in automatically because those classes get extended.
#

ruboto_import_widgets :LinearLayout, :EditText, :TextView

#
# $activity is the Activity that launched the 
# script engine. The start_ruboto_activity
# method creates a new RubotoActivity to work with.
# After launch, the new activity can be accessed 
# through the $ruboto_demo (in this case) global.
# You man not need the global, because the block
# to start_ruboto_activity is executed in the 
# context of the new activity as it initializes. 
#
$activity.start_ruboto_activity "$ruboto_demo" do
  #
  # setup_content uses methods created through
  # ruboto_import_widgets to build a UI. All
  # code is executed in the context of the 
  # activity.
  #
  setup_content do
    linear_layout(:orientation => LinearLayout::VERTICAL) do
      @et = edit_text
      linear_layout do
        button :text => "Hello, World"
        button :text => "Hello, Ruboto"
        button :text => "List"
      end
      @tv = text_view :text => "Click buttons or menu items:"
    end
  end

  #
  # All "handle" methods register for the 
  # corresponding callback (in this case 
  # OnCreateOptionsMenu. Creates menus that
  # execute the corresponding block (still
  # in the context of the activity)
  #
  handle_create_options_menu do |menu|
    add_menu("Hello, World") {my_click "Hello, World"}
    add_menu("Hello, Ruboto") {my_click "Hello, Ruboto"}
    add_menu("Exit") {finish}
    true
  end

  #
  # Another callback method for OnClick. Buttons
  # automatically get the activity as a handler.
  #
  handle_click do |view|
    case view.getText
      when "List"
        launch_list
      else
        my_click(view.getText)
    end
  end

  #
  # Extra singleton methods for this activity
  # need to be declared with self. This one 
  # handles some of the button and menu clicks.
  # 
  def self.my_click(text)
    toast text
    @tv.append "\n#{text}"
    @et.setText text
  end

  #
  # Launches a separate activity for displaying
  # a ListView.
  #
  def self.launch_list
    self.start_ruboto_activity("$my_list") do
      setTitle "Pick Something"
      @list = ["Hello, World", "Hello, Ruboto"]
      setup_content {list_view :list => @list}
      handle_item_click do |adapter_view, view, pos, item_id| 
        toast(@list[pos])
        finish
      end
    end
  end
end
