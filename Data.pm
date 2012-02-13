package Clone::Data;

use Exporter;
use XSLoader;

$VERSION = '0.01';
@EXPORT = 'clone';
@ISA = 'Exporter';

XSLoader::load(__PACKAGE__, $VERSION);

1;
