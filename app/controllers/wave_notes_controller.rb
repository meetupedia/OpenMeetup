# encoding: UTF-8

class WaveNotesController < CommonController
  load_resource
  authorize_resource

  def index
    @wave_notes = current_user.wave_notes.order('created_at DESC').all :include => {:wave => :users}
    current_user.wave_notes.destroy_all
    User.dirty_reset_counters current_user.id, :wave_notes
    @title = 'Friss üzenetek'
    @sidebar = 'waves/sidebar'
  end
end
