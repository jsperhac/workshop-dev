# protein explorations

# load data sets from csv files

# Let's explore a few basic characteristics of proteins. We'll plot protein molecular weight and sequence 
# length, by p_number (in sample data frame) 


# --------- scatterplot of protein molecular weight vs. sequence length ------------

# The protein's sequence length is the number of amino acids that comprise it.
# The molecular weight is the sum of the masses of all its amino acids.

# Create a scatterplot of experimental_molecular_weight vs. seq_len for the 13 proteins
# in our dataset.
# Make and plot a 'linear model'. Does it look like a linear relationship?

# Determine the correlation of seq_len and experimental_molecular_weight.
# Why do you think these values are related?
# Reference: 
#   http://tinyurl.com/mpdr2w7


# ---------- derivation of protein's estimated molecular weight ------------------

# As you have seen, there is a relationship between the number of amino acids in a protein
# and its molecular weight (MW). Let's test a rule about this by deriving the molecular weight
# of our 13 proteins, using the sequence length (the number of amino acids).

# Approximate the molecular weights of all the proteins in the dataset, using:
# Approximate Molecular Weight of a Protein
# M.W. of protein = # amino acids x 110 Da

# Now plot the derived MW against the experimental MW, plot a linear fit, 
# and compute the correlation.
# Does this look like a reasonable approximation to you?

