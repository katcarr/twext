class TextsController<ApplicationController
  def new
    @contact = Contact.find(params[:contact_id])
    @text = @contact.texts.new
    response do |format|
      format.html {redirect_to :back}
      format.js
    end
  end

  def create
    @contact = Contact.find(params[:contact_id])
    @text = Text.new(text_params)
    @text.user_id = current_user.id
    @text.from = ENV['OUR_TWILIO_NUMBER']
    @text.to = @contact.number
    @text.save
    @contact.save

    if @text.save
      flash[:notice] = "Message Successfully Sent"
      redirect_to user_path(current_user)

    else
      errors = ""
      @text.errors.messages[:base].each do |e|
        if e == @text.errors.messages[:base].first
          errors = errors + e
        else
          errors = errors + '\n' + e
        end
      end
      flash[:alert] = errors
      redirect_to :back
    end
  end


  private

  def text_params
    params.require(:text).permit(:to, :body, :contact_id)
  end

end
