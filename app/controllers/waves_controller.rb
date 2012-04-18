# encoding: UTF-8

class WavesController < ApplicationController
  load_resource :group
  load_resource :wave, :through => :group, :shallow => true, :except => [:with_user]
  authorize_resource

  def index
    @waves = Wave.order('last_changed_at DESC').paginate :joins => :wave_memberships, :conditions => {'wave_memberships.user_id' => current_user.id, 'wave_memberships.is_archived' => false, 'wave_memberships.is_deleted' => false}, :include => [:users, :wave_notes], :page => params[:page]
    @title = 'Bejövő üzenetek'
  end

  def show
    @wave = Wave.find(params[:id])
    if @wave.wave_membership_for(current_user) or @wave.user == current_user
      if wave_note = WaveNote.find_by_wave_id_and_user_id(@wave.id, current_user.id)
        @note_created_at = wave_note.created_at
        wave_note.destroy
        current_user.reload
      end
      @wave_items = @wave.wave_items.order('created_at DESC').paginate :include => [{:reply_to => :user}, :user], :page => params[:page]
      @title = 'Üzenet: ' + @wave.subject
    else
      flash[:alert] = 'Nem tekintheted meg ezt a folyamot!'
      redirect_to waves_url
    end
  end

  def new
    @recipient_id = params[:recipient_id]
    render :layout => false if request.xhr?
  end

  def create
    @wave = Wave.new(params[:wave])
    if @wave.save
      if params[:wave_membership] and not params[:wave_membership][:user_id].blank? and user = User.find_by_id(params[:wave_membership][:user_id])
        WaveMembership.create(:user_id => user.id, :wave_id => @wave.id) unless user.blocked_user_ids.include?(current_user.id)
      end
      wave_item = WaveItem.create(:user_id => current_user.id, :wave_id => @wave.id, :body => params[:body]) if params[:body]
      redirect_to @wave
    else
      render :new
    end
  end

  def edit
    @wave_membership = @wave.wave_membership_for(current_user)
    render :layout => false if request.xhr?
  end

  def all
    @waves = Wave.order('last_changed_at DESC').paginate :joins => :wave_memberships, :conditions => {'wave_memberships.user_id' => current_user.id, 'wave_memberships.is_deleted' => false}, :include => [:users, :wave_notes], :page => params[:page]
    @title = 'Összes üzenet'
    render :index
  end

  def own
    @waves = current_user.waves.order('last_changed_at DESC').paginate :joins => :wave_memberships, :conditions => {'wave_memberships.user_id' => current_user.id, 'wave_memberships.is_deleted' => false}, :include => [:users, :wave_notes], :page => params[:page]
    @title = 'Saját üzenetek'
    render :index
  end

  def starred
    @waves = Wave.order('last_changed_at DESC').paginate :joins => :wave_memberships, :conditions => {'wave_memberships.user_id' => current_user.id, 'wave_memberships.is_starred' => true, 'wave_memberships.is_deleted' => false}, :include => [:users, :wave_notes], :page => params[:page]
    @title = 'Csillagozott üzenetek'
    render :index
  end

  def with_user
    @user = User.find_by_id params[:id]
    if @user
      @waves = (Wave.order('last_changed_at DESC').all(:joins => :wave_memberships, :conditions => {'wave_memberships.user_id' => @user.id}, :include => [:users, :wave_notes]) & current_user.joined_waves.all(:include => [:users, :wave_notes])).paginate :per_page => Wave.per_page, :page => params[:page]
      @title = "Üzenetváltások vele: #{@user.login}"
      render :index
    else
      redirect_to root_url, :alert => 'Nincsen ilyen tag!'
    end
  end
end
