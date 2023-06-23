"""This program counts the number of times each unique word appears in
a text file. The results are output to the command line, and the user
is given the option of printing the results to a new text file."""

user_input = input("Provide each unique word here: ")
user_input2 = input("The number of times each respective word appears: ")
words = user_input.split()
frequency = user_input2.split()

word_count = {}
word_count[words[0]] = frequency[0]
word_count[words[1]] = frequency[1]
word_count[words[2]] = frequency[2]
word_count[words[3]] = frequency[3]
check_word = input("Which word would you like to check? ")
word_exists = check_word in word_count
freq = word_count[check_word]
print("The word '{}' is in the dictionary: {} {} times!".format(check_word, word_exists,freq ))
# user_input = input("Provide words here: ")
# results_list = user_input.split()
# user_input2 = input("Provide more words here")
# results_list2 = user_input2.split()
# added_results = results_list + results_list2
# print(added_results)
#
# append_input = input("What word would you like to append? ")
# added_results.append(append_input)
# print(added_results)
# remove_input = input("What word would you like to remove? ")
# added_results.remove(remove_input)
# print(added_results)

# user_input = input("Please enter the path and name of the text file you want"
#                   " to analyze. (E.g.: C:/Users/Monty/Desktop/file.txt):"
#                   "\n")

# common_word = input("Would you like to strip common words from the results? (Y/N) ")

# user_output = input("\nWould you like to output these results to a file? (Y/N) ")
