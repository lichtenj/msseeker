use strict;

my $input = "../MD_example.fa";		#input fasta
my $length = 5;				#kmer length
my $min_count = 5;			#Minimum total number of occurrences
my $min_seq = 1;			#Minimum number of sequences in which kmer occurs
my $result_hash;

my $current_id = "";
my $current_sequence = "";
open(IN,$input) or die "Cannot open $input";
while(my $rec = <IN>)
{
	chomp($rec);

	if($rec =~ /^\>/)
	{
		if(length($current_sequence) > 0)
		{
			for(my $i=0;$i< length($current_sequence) - $length + 1;$i++)
			{
				$result_hash->{substr($current_sequence,$i,$length)}->{'COUNT'}++;
				$result_hash->{substr($current_sequence,$i,$length)}->{'SEQUENCES'}->{$current_id}++;
			}
		}

		$rec =~ s/^\>\s*//;
		$current_id = $rec;
		$current_sequence = "";
	}
	else
	{
		$current_sequence .= $rec;
	}
}
if(length($current_sequence) > 0)
{
	for(my $i=0;$i<length($current_sequence) - $length + 1;$i++)
	{
		$result_hash->{substr($current_sequence,$i,$length)}->{'COUNT'}++;
		$result_hash->{substr($current_sequence,$i,$length)}->{'SEQUENCES'}->{$current_id}++;
	}
}

foreach my $kmer (keys %$result_hash)
{
	if($result_hash->{$kmer}->{'COUNT'} > 1)
	{
		print $kmer."\t".$result_hash->{$kmer}->{'COUNT'};
		print "\t";
#		foreach my $seq (keys %{$result_hash->{$kmer}->{'SEQUENCES'}})
#		{
#			print "\t".$seq.' ('.$result_hash->{$kmer}->{'SEQUENCES'}->{$seq}.')';
#		}
		print scalar(keys %{$result_hash->{$kmer}->{'SEQUENCES'}});
		print "\n";
	}
}
