use strict;

my $input = "../MD_example.fa";		#input fasta
my $length = 5;				#kmer length
my $min_count = 5;			#Minimum total number of occurrences
my $min_seq = 1;			#Minimum number of sequences in which kmer occurs
my $hash;

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
			$hash->{$current_id} = $current_sequence;
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
	$hash->{$current_id} = $current_sequence;
}

my $result_hash;
foreach my $id (keys %$hash)
{
#	print $id."\n";
#	print $hash->{$id}."\n";

	for(my $i=0;$i<=length($hash->{$id})-$length;$i++)
	{
		$result_hash->{substr($hash->{$id},$i,$length)}->{'COUNT'}++;
		$result_hash->{substr($hash->{$id},$i,$length)}->{'SEQUENCES'}->{$id} = 1;
	}
}

foreach my $kmer (keys %$result_hash)
{
	if($result_hash->{$kmer}->{'COUNT'} > 1)
	{
		print $kmer."\t".$result_hash->{$kmer}->{'COUNT'}."\t";
		print scalar(keys %{$result_hash->{$kmer}->{'SEQUENCES'}})."\n";
	}
}
