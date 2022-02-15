use File::Copy;
use Cwd;
use File::Copy "cp";

NIC->prompt("APPVERSION", "Version of the app", {default => ""});

NIC->prompt("HACKNAME", "Name of the hack", {default => ""});

NIC->prompt("BINARYNAME", "Name of the binary", {default => ""});

NIC->prompt("APPDELEGATE", "What is the AppDelegate", {default => ""});

my $default_kill = "SpringBoard";

NIC->variable("KILL_RULE") = "";

my $kill_apps = NIC->prompt("KILL_APPS", "List of applications to terminate upon installation (space-separated, '-' for none)", {default => $default_kill});
if($kill_apps ne "-") {
	my @apps = split(/\s+/, $kill_apps);
	my @commands = map {"killall -9 $_"} @apps;
	NIC->variable("KILL_RULE") = "after-install::\n\tinstall.exec \"".join("; ", @commands)."\"";
}
