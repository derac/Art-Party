const MIN_LENGTH = 3
const MAX_LENGTH = 7
const LETTERS = {
	'VOYELLE': ['a', 'e', 'a', 'e', 'i', 'o', 'o', 'a', 'e', 'a', 'e', 'i', 'a', 'e', 'a', 'e', 'i', 'o', 'o', 'a', 'e', 'a', 'e', 'i', 'y'],
	'DOUBLE_VOYELLE': ['oi', 'ai', 'ou', 'ei', 'ae', 'eu', 'ie', 'ea'],
	
	'CONSONNE': ['b', 'c', 'c', 'd', 'f', 'g', 'h', 'j', 'l', 'm', 'n', 'n', 'p', 'r', 'r', 's', 't', 's', 't', 'b', 'c', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'n', 'p', 'r', 'r', 's', 't', 's', 't', 'v', 'w', 'x', 'z'],
	'DOUBLE_CONSONNE': ['mm', 'nn', 'st', 'ch', 'll', 'tt', 'ss'],
	
	'COMPOSE': ['qu', 'gu', 'cc', 'sc', 'tr', 'fr', 'pr', 'br', 'cr', 'ch', 'll', 'tt', 'ss', 'gn']
}

const TRANSITION = {
	'INITIAL': ['VOYELLE', 'CONSONNE'],
	'VOYELLE': ['CONSONNE', 'DOUBLE_CONSONNE', 'COMPOSE'],
	'DOUBLE_VOYELLE': ['CONSONNE', 'DOUBLE_CONSONNE', 'COMPOSE'],
	
	'CONSONNE': ['VOYELLE', 'DOUBLE_VOYELLE'],
	'DOUBLE_CONSONNE': ['VOYELLE', 'DOUBLE_VOYELLE'],
	
	'COMPOSE': ['VOYELLE']
}

static func pick_random_number(max_value : int, min_value := 0) -> int:
	randomize()
	
	return int(round(randi() % (max_value - min_value) + min_value))

static func clone_array(original : Array) -> Array:
	var result = []
	
	for item in original:
		result.append(item)
	
	return result

static func get_letter(state : String, max_length : int) -> Array:
	var transitions = clone_array(TRANSITION[state])
	
	if max_length < 3:
		transitions.erase('COMPOSE')
		transitions.erase('DOUBLE_CONSONNE')
		transitions.erase('DOUBLE_VOYELLE')
	
	var state_index = pick_random_number(transitions.size())
	
	state = transitions[state_index]
	
	var letters_list = LETTERS[state]
	var letter_index = pick_random_number(letters_list.size())

	return [state, letters_list[letter_index]]

static func generate(min_length := MIN_LENGTH, max_length := MAX_LENGTH) -> String:
	var length = pick_random_number(max_length, min_length)
	var name = ''
	var last_letter = ''
	var index = 0
	var state = 'INITIAL'

	while index < length:
		var obj = get_letter(state, length - index)
		
		state = obj[0]
		last_letter = obj[1]
		
		name += last_letter
		index += last_letter.length()

	return name.capitalize()
	
#MIT License
#
#Copyright (c) 2017 Xavier Sellier
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.
