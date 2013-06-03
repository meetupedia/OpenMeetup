# encoding: UTF-8

class WavesController < CommonController
  load_resource
  authorize_resource

  def index
    @waves = Wave.order('last_changed_at DESC').paginate joins: :wave_memberships, conditions: {'wave_memberships.user_id' => current_user.id, 'wave_memberships.is_archived' => false, 'wave_memberships.is_deleted' => false}, include: [:users, :wave_notes], page: params[:page]
  end

  def show
    @wave = Wave.find(params[:id])
    if @wave.wave_membership_for(current_user) or @wave.user == current_user
      if wave_note = WaveNote.find_by_wave_id_and_user_id(@wave.id, current_user.id)
        @note_created_at = wave_note.created_at
        wave_note.destroy
        current_user.reload
      end
      @wave_items = @wave.wave_items.order('created_at DESC').includes(:user).paginate page: params[:page]
    else
      flash[:alert] = 'Nem tekintheted meg ezt a folyamot!'
      redirect_to waves_url
    end
  end

  def new
    @recipient = User.find_by_id(params[:recipient_id]) if params[:recipient_id].present?
  end

  def create
    @wave = Wave.new(params[:wave])
    if @wave.save
      if @wave.recipient_id.present? and user = User.find_by_id(@wave.recipient_id)
        @wave.add_wave_member(user)
      end
      wave_item = WaveItem.create(wave_id: @wave.id, body: @wave.body)
      redirect_to @wave
    else
      render :new
    end
  end

  def all
    @waves = Wave.order('last_changed_at DESC').paginate joins: :wave_memberships, conditions: {'wave_memberships.user_id' => current_user.id, 'wave_memberships.is_deleted' => false}, include: [:users, :wave_notes], page: params[:page]
    render :index
  end
end
