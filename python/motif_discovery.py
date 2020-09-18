input = "../MD_example.fa"
length = 5
min_count = 1
file=open(input,'r')
lines=file.readlines()

result_dict = {}
current_sequence = ""
current_id = ""

for line in lines:
	line = line.strip()

	if line.startswith(">"):
		#Do kmer parsing on current sequnce if current sequnce > 0
		if len(current_sequence) > 0:
			#Do kmer parsing
			for i in range (0,len(current_sequence)-length+1):
				if current_sequence[i:i+length] in result_dict:
					#result_dict[current_sequence[i:i+length]] += 1
					#result_dict[current_sequence[i:i+length]]={'count': result_dict[current_sequence[i:i+length]]['count'] + 1,'sequence': ('t1','t2')}
					result_dict[current_sequence[i:i+length]]['count'] += 1
					try:
						 result_dict[current_sequence[i:i+length]]['sequence'][current_id] += 1
					except KeyError:
						result_dict[current_sequence[i:i+length]]['sequence'][current_id] = 1
				else:
					#result_dict[current_sequence[i:i+length]] = 1
					result_dict[current_sequence[i:i+length]]={'count': 1,'sequence': { current_id : 1}}

		current_id = line[1:]
		current_sequence = ""
	else:
		#Appent to current sequence
		current_sequence += line

if len(current_sequence) > 0:
	#Do kmer parsing
	#print(current_id)
	#print(current_sequence)
	for i in range (0,len(current_sequence)-length+1):
		if current_sequence[i:i+length] in result_dict:
			#result_dict[current_sequence[i:i+length]] += 1
			#result_dict[current_sequence[i:i+length]]={'count': result_dict[current_sequence[i:i+length]]['count'] + 1,'sequence': ('t1','t2')}
			result_dict[current_sequence[i:i+length]]['count'] += 1
			try:
				result_dict[current_sequence[i:i+length]]['sequence'][current_id] += 1
			except KeyError:
				result_dict[current_sequence[i:i+length]]['sequence'][current_id] = 1
		else:
			#result_dict[current_sequence[i:i+length]] = 1
			result_dict[current_sequence[i:i+length]]={'count': 1,'sequence': { current_id : 1}}

for substr in result_dict:
	if(result_dict[substr]['count'] > min_count):
		print(substr + "\t" + repr(result_dict[substr]['count']) + "\t" + repr(len(result_dict[substr]['sequence'])))
		#print(result_dict[substr])
