class GamesController < ApplicationController

  def index
    @games = Game.all
    @game = Game.new
    @teams = Team.all
    @players = Player.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
  	@top_team = Team.find(@game.top_team_id)
    @bottom_team = Team.find(@game.bottom_team_id)
    @top_players = Affiliation.find(:all, :conditions => { :team_id => @game.top_team_id})
    @bottom_players = Affiliation.find(:all, :conditions => { :team_id => @game.bottom_team_id})
    @inning = 1
    @strike = 0
    @ball = 0
    @out = 0
    @top_score = 0
    @bottom_score = 0
    @position = ["P", "C", "1B", "2B", "3B", "SS", "LF", "CF", "RF"]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # POST /affiliations
  # POST /affiliations.json
  def create
    @games = Game.all
    @game = Game.new(params[:game])
    @teams = Team.all
    @players = Player.all

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "index" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @teams = Team.all
    @players = Player.all
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

end
