#encoding: utf-8
class TchatmessagesController < DiscussionsController
  before_filter :signed_in_user
  before_filter :notskin_user, only: [:create]
  before_filter :is_involved_2, only: [:create]

  def create
    link = current_user.sk.links.where(:discussion_id => @discussion.id).first
    if link.nonread > 0
      session[:ancientexte] = params[:content]
      flash[:danger] = "Un message a été envoyé avant le vôtre."
      redirect_to @discussion and return
    end

    @destinataire = current_user.sk
    @discussion.users.each do |u|
      if u != current_user.sk
        @destinataire = u
      end
    end

    @content = params[:content]

    send_message

    if @erreur
      redirect_to @discussion
    else
      @discussion.links.each do |l|
        if l.user_id != current_user.sk.id
          l.nonread = l.nonread + 1
        else
          l.nonread = 0
        end
        l.save
      end
      @discussion.last_message = DateTime.now
      @discussion.save
      redirect_to @discussion
    end
  end

  ########## PARTIE PRIVEE ##########
  private

  def is_involved_2
    @discussion = Discussion.find(params[:tchatmessage][:discussion_id])
    if !current_user.sk.discussions.include?(@discussion)
      redirect_to new_discussion_path
    end
  end
  
  def is_not_other
  	if current_user.other
  		flash[:danger] = "Vous êtes dans la peau de quelqu'un d'autre!"
  		redirect_to @discussion
  	end
  end
end
