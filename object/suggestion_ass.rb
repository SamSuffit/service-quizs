# -*- coding: utf-8 -*-

# Objet suggestion_ass permettant de faire le lien avec la BDD
class SuggestionASS < Suggestion
	include Outils

	# Initialise l'objet avec les paramètres suivant
	# Paramètres obligatoires
	# id auto_increment
	# question_id Integer 
	# text String
	# Paramètres facultatifs
	# order Integer
	# medium_id Integer
	# position Enum ('L', 'R')
	def initialize ( params = {} )
		super(params)
	end

	# Permet de savoir si la suggestion est solution 
	# et de retourner les suggestions associées
  def solution?
  	is_solution = false
  	if @position == 'L'
  		solutions = Solutions.where(:left_suggestion_id => @id)
  		unless solutions.nil? && solutions.empty?
  			is_solution = []
  			solutions.each do |solution|
          order = SuggestionASS.new({id: solution.right_suggestion_id})
          order = order.find.order
  				is_solution.push(order)
  			end
  		end
    end
  	if @position == 'R'
			solutions = Solutions.where(:right_suggestion_id => @id)
  		unless solutions.nil? && solutions.empty?
  			is_solution = []
  			solutions.each do |solution|
          order = SuggestionASS.new({id: solution.left_suggestion_id})
          order = order.find.order
  				is_solution.push(order)
  			end
  		end
  	end
  	is_solution
  end

  # Récupère les ids des suggestions de la question
  def find_all_ids
    ids = []
    datas = Suggestions.where(:question_id => @question_id).select(:id)
    datas.each do |data|
      ids.push(data.id)
    end
    ids
  end

  # Récupère les ids des solutions de la question
  def find_all_solutions_ids
    ids = []
    left_suggestions_ids = []
    # On récupère toutes les suggestions gauche
    Suggestions.where(:question_id => @question_id, :position => @position).select(:id).each do |left_suggestion|
      left_suggestions_ids.push(left_suggestion.id);
    end
    datas = Solutions.where(:left_suggestion_id => left_suggestions_ids).select(:id)
    datas.each do |data|
      ids.push(data.id)
    end
    ids
  end
end