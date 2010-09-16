#!perl -T

use Test::More 'no_plan';
use Finance::OFX::Parse::Simple;

my $parser = Finance::OFX::Parse::Simple->new;

ok( (not defined $parser->parse_file),
    "File parser returns undef with no filename");

ok( (not defined $parser->parse_file("/this/file/does/not/exist")),
    "File parser returns undef for a file which does not exist");

ok( (not defined $parser->parse_scalar),
    "Scalar parser returns undef with no scalar");

my $ofx_data = qq[<OFX>
		  <SIGNONMSGSRSV1>
		  <SONRS>
		  <STATUS>
		  <CODE>0
		  <SEVERITY>INFO
		  </STATUS>
		  <DTSERVER>20081219100804[-5:EST]
		  <LANGUAGE>ENG
		  </SONRS>
		  </SIGNONMSGSRSV1>
		  <BANKMSGSRSV1>
		  <STMTTRNRS>
		  <TRNUID>1
		  <STATUS>
		  <CODE>0
		  <SEVERITY>INFO
		  </STATUS>
		  <STMTRS>
		  <CURDEF>GBP
		  <BANKACCTFROM>
		  <BANKID>999999
		  <ACCTID>1234567
		  <ACCTTYPE>CHECKING
		  </BANKACCTFROM>
		  <BANKTRANLIST>
		  <DTSTART>20080601000000[-5:EST]
		  <DTEND>20080630000000[-5:EST]
		  <STMTTRN>
		  <TRNTYPE>OTHER
		  <DTPOSTED>20080603000000[-5:EST]
		  <TRNAMT>36.05
		  <FITID>+20080603000001
		  <NAME>Transaction $$
		  </STMTTRN>
		  </BANKTRANLIST>
		  <LEDGERBAL>
		  <BALAMT>1668.75
		  <DTASOF>20081219000000[-5:EST]
		  </LEDGERBAL>
		  </STMTRS>
		  </STMTTRNRS>
		  </BANKMSGSRSV1>
		  </OFX>
		  ];

ok( (ref($parser->parse_scalar($ofx_data)) eq 'ARRAY'),
    "Parse scalar returns a list reference");

ok( (ref($parser->parse_scalar($ofx_data)->[0]) eq 'HASH'),
    "Parser's list reference contains hash references");

ok( ($parser->parse_scalar($ofx_data)->[0]->{transactions}->[0]->{name} eq "Transaction $$"),
    "OFX data is parsed correctly");
