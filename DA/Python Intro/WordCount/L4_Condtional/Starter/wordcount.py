"""This program counts the number of times each unique word appears in
a text file. The results are output to the command line, and the user
is given the option of printing the results to a new text file."""

COMMON_WORDS = {"the", "be", "are", "is", "were", "was", "am",
                "been", "being", "to", "of", "and", "a", "in",
                "that", "have", "had", "has", "having", "for",
                "not", "on", "with", "as", "do", "does", "did",
                "doing", "done", "at", "but", "by", "from"}

read_input = ["This", "is", "a", "test!", "this", "is,", "another", "test.",
              "TesT", "value", "this", "!test", "is?"]
read_wordlist = ["this", "is", "a", "test"]

word_count = {}

user_input = input("Please enter the path and name of the text file you want"
                   " to analyze. (E.g.: C:/Users/Monty/Desktop/file.txt):"
                   "\n")

common_word = input("Would you like to strip common words from the results? "
                    "(Y/N) ")

user_output = input("\nWould you like to output these results to a file? "
                    "(Y/N) ")
