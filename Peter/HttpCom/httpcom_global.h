#ifndef HTTPCOM_GLOBAL_H
#define HTTPCOM_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(HTTPCOM_LIBRARY)
#  define HTTPCOMSHARED_EXPORT Q_DECL_EXPORT
#else
#  define HTTPCOMSHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // HTTPCOM_GLOBAL_H
