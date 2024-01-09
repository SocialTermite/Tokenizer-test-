Create a tokenizer that tokenizes the sentence whenever there is the word "if" and "and" and classifies it as a new sentence. One thing is that it should also have the option for another language like if the language is English it should only identify the words "if" and "and", but if it's Spanish it should only identify the words "Si" and "Y"

example

Hi my name is Oxus and I am here to start the project (typing in real time)

Output:
- Hi my name is Oxus
- And I am here to start the project
