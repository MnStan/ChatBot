import csv
import os
import random
import math
from collections import Counter

# Function to calculate similarity using Levenshtein distance considering replacements
def similarity_from_levenshtein_replacement(str1, str2):
    max_len = max(len(str1), len(str2))
    distance = levenshtein_distance_replacement(str1, str2)
    return (max_len - distance) / max_len

# Function to calculate similarity using Levenshtein distance considering swapping
def similarity_from_levenshtein_swapping(str1, str2):
    max_len = max(len(str1), len(str2))
    distance = levenshtein_distance_swapping(str1, str2)
    return (max_len - distance) / max_len

# Function to calculate Levenshtein distance between two strings
def levenshtein_distance_replacement(str1, str2):
    n_m = [[0 for j in range(len(str2) + 1)] for i in range(len(str1) + 1)]
    for i in range(len(str1) + 1):
        for j in range(len(str2) + 1):
            if i == 0:
                n_m[i][j] = j
            elif j == 0:
                n_m[i][j] = i
            else:
                if str1[i - 1] == str2[j - 1]:
                    n_m[i][j] = n_m[i - 1][j - 1]
                else:
                    n_m[i][j] = n_m[i - 1][j - 1] + 1
    return n_m[-1][-1]

# Function to calculate Levenshtein distance considering swapping
def levenshtein_distance_swapping(str1, str2):
    n_m = [[0 for j in range(len(str2) + 1)] for i in range(len(str1) + 1)]
    for i in range(len(str1) + 1):
        for j in range(len(str2) + 1):
            if i == 0:
                n_m[i][j] = j
            elif j == 0:
                n_m[i][j] = i
            else:
                if str1[i - 1] == str2[j - 1]:
                    n_m[i][j] = n_m[i - 1][j - 1]
                else:
                    if i > 1 and j > 1 and str1[i - 1] == str2[j - 2] and str1[i - 2] == str2[j - 1]:
                        n_m[i][j] = n_m[i - 2][j - 2] + 1
                    else:
                        n_m[i][j] = min(n_m[i - 1][j - 1], n_m[i - 1][j], n_m[i][j - 1]) + 1
    return n_m[-1][-1]
    
# Function to calculate Levenshtein distance between two strings
def levenshtein_distance(str1, str2):
    n_m = [[0 for j in range(len(str2) + 1)] for i in range(len(str1) + 1)]
    for i in range(len(str1) + 1):
        for j in range(len(str2) + 1):
            if i == 0:
                n_m[i][j] = j
            elif j == 0:
                n_m[i][j] = i
            else:
                if str1[i - 1] == str2[j - 1]:
                    n_m[i][j] = n_m[i - 1][j - 1]
                else:
                    min_operation = min(n_m[i - 1][j], n_m[i][j - 1], n_m[i - 1][j - 1])
                    n_m[i][j] = min_operation + 1
    return n_m[-1][-1]

# Function to calculate similarity using Levenshtein distance
def similarity_from_levenshtein(str1, str2):
    max_len = max(len(str1), len(str2))
    distance = levenshtein_distance(str1, str2)
    return (max_len - distance) / max_len
    
# Function to calculate Hamming distance between two strings
def hamming_distance(str1, str2):
    if len(str1) != len(str2):
        return max(len(str1), len(str2))  # Return maximum possible distance if lengths differ
    return sum(c1 != c2 for c1, c2 in zip(str1, str2))

# Function to calculate similarity using Hamming distance
def similarity_from_hamming(str1, str2):
    if len(str1) != len(str2):
        return 0
    distance = hamming_distance(str1, str2)
    return (len(str1) - distance) / len(str1)

# Function to calculate Jaro-Winkler similarity
def jaro_winkler_similarity(s1, s2):
    jaro_dist = jaro_distance(s1, s2)
    prefix_len = 0
    for c1, c2 in zip(s1, s2):
        if c1 == c2:
            prefix_len += 1
        else:
            break
        if prefix_len == 4:
            break
    return jaro_dist + 0.1 * prefix_len * (1 - jaro_dist)

def jaro_distance(s1, s2):
    if s1 == s2:
        return 1.0
    
    len1, len2 = len(s1), len(s2)
    max_dist = (max(len1, len2) // 2) - 1
    match = 0
    hash_s1 = [0] * len1
    hash_s2 = [0] * len2

    for i in range(len1):
        for j in range(max(0, i - max_dist), min(len2, i + max_dist + 1)):
            if s1[i] == s2[j] and hash_s2[j] == 0:
                hash_s1[i] = 1
                hash_s2[j] = 1
                match += 1
                break

    if match == 0:
        return 0.0

    t = 0
    point = 0

    for i in range(len1):
        if hash_s1[i]:
            while hash_s2[point] == 0:
                point += 1
            if s1[i] != s2[point]:
                t += 1
            point += 1

    t //= 2
    return (match / len1 + match / len2 + (match - t) / match) / 3.0

# Function to calculate cosine similarity between two strings
def cosine_similarity(s1, s2):
    vec1 = Counter(s1)
    vec2 = Counter(s2)
    intersection = set(vec1.keys()) & set(vec2.keys())
    numerator = sum([vec1[x] * vec2[x] for x in intersection])

    sum1 = sum([vec1[x] ** 2 for x in vec1.keys()])
    sum2 = sum([vec2[x] ** 2 for x in vec2.keys()])
    denominator = math.sqrt(sum1) * math.sqrt(sum2)

    if not denominator:
        return 0.0
    else:
        return float(numerator) / denominator

# Function to calculate Jaccard index between two strings
def jaccard_index(s1, s2):
    set1 = set(s1)
    set2 = set(s2)
    intersection = set1.intersection(set2)
    union = set1.union(set2)
    return len(intersection) / len(union)

# Function to calculate Q-gram distance between two strings
def qgram_distance(s1, s2, q=2):
    def qgrams(s, q):
        return [s[i:i+q] for i in range(len(s) - q + 1)]
    
    qgrams1 = qgrams(s1, q)
    qgrams2 = qgrams(s2, q)
    set1 = set(qgrams1)
    set2 = set(qgrams2)
    
    return len(set1.union(set2)) - len(set1.intersection(set2))

# Function to calculate similarity using Q-gram distance
def similarity_from_qgram(str1, str2, q=2):
    max_len = max(len(str1), len(str2))
    distance = qgram_distance(str1, str2, q)
    return (max_len - distance) / max_len
    
def find_similar_question(user_question, database, algorithm):
    max_similarity = 0
    most_similar_question = None
    similarity_funcs = [
        similarity_from_levenshtein,
        similarity_from_levenshtein_replacement,
        similarity_from_levenshtein_swapping,
        similarity_from_hamming,
        jaro_winkler_similarity,
        cosine_similarity,
        jaccard_index,
        similarity_from_qgram
    ]
    
    if algorithm == 0:
        selected_funcs = similarity_funcs
    else:
        selected_funcs = [similarity_funcs[algorithm - 1]]
    
    for question in database:
        similarities = [func(user_question.lower(), question) for func in selected_funcs]
#        average_similarity = sum(similarities) / len(similarities)
        if max(similarities) > max_similarity:
            max_similarity = max(similarities)
            most_similar_question = question
    return most_similar_question, max_similarity
    
# Function to load question-answer pairs from a CSV file
def load_database(filename):
    database = {}
    
    script_dir = os.path.dirname(os.path.realpath(__file__))
    os.chdir(script_dir)
    
    with open(filename, 'r', newline='', encoding='utf-8-sig') as file:
        reader = csv.reader(file, delimiter='-')
        for row in reader:
            if len(row) == 2:
                question, answer = row
                question = question.strip().lower()
                if question in database:
                    database[question].append(answer.strip())
                else:
                    database[question] = [answer.strip()]
            else:
                print(f"Invalid row format: {row}")
    return database

def chatbot(database, text, algorithm, userSimilarity):
    user_question = text.strip().lower()
    most_similar_question, similarity = find_similar_question(user_question, database, algorithm)
    if similarity > userSimilarity:
        return (random.choice(database[most_similar_question]), similarity)
    else:
        return ("Sorry, I don't have an answer to that question.", similarity)

def getAnswer(text, algorithm, userSimilarity):
    database = load_database("Database.csv")
    toReturn = chatbot(database, text, algorithm, userSimilarity)
    return (toReturn[0], toReturn[1])
