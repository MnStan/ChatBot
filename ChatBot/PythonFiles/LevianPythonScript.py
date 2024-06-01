import csv
import os

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
    
def find_similar_question(user_question, database):
    max_similarity = 0
    most_similar_question = None
    for question in database:
        similarity_replacement = similarity_from_levenshtein_replacement(user_question.lower(), question)
        similarity_swapping = similarity_from_levenshtein_swapping(user_question.lower(), question)
        # Choose the maximum similarity from both methods
        similarity = max(similarity_replacement, similarity_swapping)
        if similarity > max_similarity:
            max_similarity = similarity
            most_similar_question = question
    return most_similar_question, max_similarity

# Function to load question-answer pairs from a CSV file
def load_database(filename):
    database = {}
    
    script_dir = os.path.dirname(os.path.realpath(__file__))
    os.chdir(script_dir)
    
    with open(filename, 'r', newline='') as file:
        reader = csv.reader(file, delimiter=';')
        for row in reader:
            if len(row) == 2:
                question, answer = row
                database[question.strip().lower()] = answer.strip()
            else:
                print(f"Invalid row format: {row}")
    return database

def chatbot(database, text):
    user_question = text.strip().lower()
    most_similar_question, similarity = find_similar_question(user_question, database)
    if similarity > 0.6:  # Adjust this threshold as needed
        return database[most_similar_question]
    else:
        return "Sorry, I don't have an answer to that question."

def getAnswer(text):
    database = load_database("Database.csv")
    return chatbot(database, text)
