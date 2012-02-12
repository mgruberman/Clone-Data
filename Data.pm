package Clone::Data;

use Exporter;
use XSLoader;

$VERSION = '0.01';
@EXPORT = 'clone';

XSLoader::load(__PACKAGE__, $VERSION);

1;
