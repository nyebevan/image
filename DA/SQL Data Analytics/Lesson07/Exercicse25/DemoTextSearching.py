from nltk.corpus import stopwords
from nltk.tokenize import word_tokenize
text = """The cat is in the box. The cat likes the box.
            The box is over the cat."""
tokens = [w for w in word_tokenize(text.lower()) if w.isalpha()]

print(tokens)

no_stops = [ t for t in tokens if t not in stopwords.words('english')]

print(no_stops)

# Counter(no_stops).most_common(2)