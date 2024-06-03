# Chatbot
  MacOS app created in SwiftUI to show functioning of a chatbot using fuzzy regular expressions to interpret user queries created as a group project for a natural language processing class.

## Table of Contents
  * [Technologies](#technologies)
  * [Algorithms](#Algorithms)
  * [App presentation](#app-presentation)

## Technologies
  Xcode - 15.4
  
  Swift
  
  SwiftUI
  
  SwiftData
  
  PythonKit framework
  

## Algorithms

Levenshtein Distance
This metric measures the difference between two sequences of words. It can be used to find the minimum number of edits required to transform one sequence of words into another. Each operation has a cost of 1 unit, and the resulting Levenshtein distance is the sum of the costs of all required operations.

Hamming Distance
Hamming distance measures the number of positions at which the corresponding symbols of two strings are different. Hamming distance can only be calculated for strings of the same length. If the strings have different lengths, the Hamming distance is defined as the maximum possible number of positions (i.e., the length of the longer string).

Jaro-Winkler Distance
This is a similarity metric between two strings, based on the number and order of common characters. It is a modification of the Jaro distance, which rewards prefixes of the strings, i.e., identical sequences at the beginning of the strings. Jaro-Winkler distance is particularly effective for short strings.

Cosine Similarity
Cosine similarity measures the similarity between two vectors by calculating the cosine of the angle between them. For strings, these vectors represent the frequency of occurrence of individual characters or n-grams (groups of characters) in the strings. The result is a value between 0 and 1, where 1 indicates identical vectors.

Jaccard Index
The Jaccard index measures the similarity between two sets by calculating the ratio of the number of common elements to the number of elements in the union of both sets. For strings, these sets can represent unique characters or n-grams. The result is a value between 0 and 1, where 1 indicates identical sets.

Q-Gram Distance
Q-gram distance measures the differences between two strings by breaking them down into substrings (n-grams) of length q and comparing these substrings. The Q-gram distance is the number of unique q-grams that differ between the strings. This method is used to assess the similarity between sequences of characters by comparing their n-grams.

## App presentation
User can see history of chats, ask a question, start new conversation, select similarity level and choose algorithm for creating answer.
  <p align="center">
    <img src="https://github.com/MnStan/ChatBot/assets/58117854/5024ccac-b09b-4e2a-9c40-4fbe7eea100a" height="500" />
  </p>

Answer from Python script is presented in chat like view. User can copy answer, or force a re-reply.
<p align="center">
    <img src="https://github.com/MnStan/ChatBot/assets/58117854/e5c0413a-2887-4a7a-bd7d-1f8e45975c22" height="500" />
  </p>

Each algorithm can produce different answers for questions due to different similarity levels that are calculated from user question.

<p align="center">
    <img src="https://github.com/MnStan/ChatBot/assets/58117854/cd738895-eb3a-4d6a-8872-9d856cc18fa2" height="500" />
  </p>

User also can search for specific message in history of chats ans see whole conversation.

<p align="center">
    <img src="https://github.com/MnStan/ChatBot/assets/58117854/5ba22e63-cb28-4713-9e7b-b9509b1c868d" height="500" />
  </p>

When selected algorithm can't find answer which similarity level is above selected threshold a message telling that Chatbot is unable to answer that question is shown.

<p align="center">
    <img src="https://github.com/MnStan/ChatBot/assets/58117854/79874857-cf5c-4f4e-b34a-60159b3e7a5b" height="500" />
  </p>

Then user can adjust similarity level and click repeat button to get answer.

<p align="center">
    <img src="https://github.com/MnStan/ChatBot/assets/58117854/e8291cab-8097-4290-ac44-ccd8e7f6994c" height="500" />
  </p>



 
