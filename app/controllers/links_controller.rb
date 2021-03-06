class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = current_user.links.new(set_params)

#    respond_to do |format|
      if @link.save
        redirect_to links_path
#      format.json { render :index, status: :created, location: @link }
      else
       render :new
      end
#    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:title, :url, :priority, :description, :image, :comment)
    end

  def set_params()
    prm = link_params
    object = get_content(prm[:url])
    prm[:title] = object.title
    prm[:description] = object.description
    prm[:comment] = ""
    prm[:priority] = convert_priority(params[:priority])
    prm[:image] = object.favicon
    prm
  end
  
  def convert_priority(priority)
    case priority
      when "for now"
        return 1
      when "for later"
        return 2
      else
        return 3
    end
  end
  
  def get_content(url)
    LinkThumbnailer.generate(url)
  end
end
