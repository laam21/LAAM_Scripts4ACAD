#!/usr/bin/perl -w

### Modified by Julien Soubrier - 2013

#The Perl script is attached as a .txt file so the virus filters don’t ban my email, just rename the extension from .txt to .pl for use. 
#Note that the way this script is written, it will convert every fasta file in the directory in which the script is run from. 
#The idea here is to create a directory and copy in all the FASTA files along with the script. 
#Then run the script and all is done. 
#You then concatenate all the separate output files into one using linux’s cat command (e.g.: cat *.fna mybigfna.fna would concatenate all .fna files in the current directory into a single fna file called mybigfna). 
#Let me know if you have any questions (George Watts <gwatts@azcc.arizona.edu)


#put this script into a directory with your .fasta files to be converted to QIIME ready .fna files. 
#Run the script and it will batch convert all fasta files to .fna
#    use strict;
#    use warnings;
my @files = <*.fasta>;
for my $file (@files){
	print "the file is $file.\n";
	my $filename = $file;
	$filename =~s/\.fasta//;
	#print "the filename is: $filename\n\n";
	
	open(FILE, "$file"); #opens file to be formatted
	open(OUT, ">$filename.fna"); #opens outfile
	#open (HEADERS, ">reheaders_$file"); #opens header outfile
	#open (SEQ, ">reseqs_$file"); #opens sequences outfile
	local $/ = undef; #slurp, mode
	
	my $input = <FILE>; # makes undef-ed file into scaler input (1 line = whole file)
	$input =~s/\>/\%%%/g;
	$input =~s/\r//g;
	#$input =~s/\n//g;
	#print "input is:\n $input";
	
	my @fields = split(/\%%%/, $input); #splits the Massive Line by "%%%" into @fields
	shift(@fields);  #adds a line to @fields
	#print "array fields is:\n @fields";
	close(FILE);
	my %fasta; #creates a hash called fasta
	my $count = 1;

	foreach $input (@fields){ #foreach line input in array fields:
		my @tmp = split(/\n/, $input, 2); #split input twice by \n into @tmp
		my $header= $tmp[0];
		my @uniqueandbarcode= split(/#/, $header);
		#print "uniqueandbarcode is now: @uniqueandbarcode \n";
		#print "header is now: $header \n";
		$header=~ s/.*//;
#		$header=~ s/.*/>$filename\_$count $uniqueandbarcode[0] orig_bc=$uniqueandbarcode[1] new_bc=$uniqueandbarcode[1] bc_diffs=0/g;
		$header=~ s/.*/>$filename\_$count $uniqueandbarcode[0] orig_bc=A new_bc=A bc_diffs=0/g;
		#print "after substitution header is now: $header \n";
		$count++;
		#print "count is now $count\n\n";
		my $seq = $tmp[1]; #saves the sequence reads (DNA) into $seq
		$seq =~s/\r//g; #sub \r or \n for nothing globally
		$seq =~s/\n//g;
		#sequences are now stored in $seq
		$fasta{$tmp[0]} = $seq; #the value $seq is now set equal to the keys in %fasta; $tmp[0] is the headers; and the {} means hash key. So header = key; sequence = value
		print OUT "$header\n$seq\n"; #prints header tab sequence \n to outfile
		# in case you want to save the headers/sequences separately.
		#print HEADERS "$header\n"; #prints headers to headers outfile
		#print SEQ "$seq\n"; #prints sequences to seq outfile
	}
}
system "cat *.fna > seqs.fna";