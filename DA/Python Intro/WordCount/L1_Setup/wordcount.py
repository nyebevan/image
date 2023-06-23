"""This program counts the number of times each unique word appears in
a text file. The results are output to the command line, and the user
is given the option of printing the results to a new text file"""

user_input = input ("please enter the path and name of the text file you want"
                    " to analyze. (E.g., C:/Users/YourName/Desktop/file.txt):"
                    "\n")
# sending user's input back to them, for now
print(user_input)

common_word = input ("Would you like to strip common words from the result? (Y/N) ")

print ( common_word)

user_output = input ("\nWould you like to output these results to a file? (Y/N) ")

print(user_output)