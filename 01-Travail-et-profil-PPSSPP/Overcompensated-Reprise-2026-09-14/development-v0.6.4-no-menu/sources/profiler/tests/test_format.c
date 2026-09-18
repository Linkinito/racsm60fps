#include "rcsm_format.h"

#include <assert.h>
#include <stdio.h>
#include <string.h>

int main(void) {
    char buffer[128];
    char tiny[5];
    const char *volatile null_string = NULL;
    assert(rcsm_format(buffer, sizeof(buffer), "L%02u 0x%08X %s %%", 1u, 0x91u, "ok") == 19u);
    assert(strcmp(buffer, "L01 0x00000091 ok %") == 0);
    assert(rcsm_format(buffer, sizeof(buffer), "%u %X", 4294967295u, 0xFFFFFFFFu) == 19u);
    assert(strcmp(buffer, "4294967295 FFFFFFFF") == 0);
    assert(rcsm_format(buffer, sizeof(buffer), "%d %d", 24576, (-2147483647 - 1)) == 17u);
    assert(strcmp(buffer, "24576 -2147483648") == 0);
    assert(rcsm_format(tiny, sizeof(tiny), "abcdef") == 4u);
    assert(strcmp(tiny, "abcd") == 0);
    assert(rcsm_format(buffer, sizeof(buffer), "%s", null_string) == 6u);
    assert(strcmp(buffer, "(null)") == 0);
    assert(rcsm_format(NULL, 0u, "ignored") == 0u);
    puts("{\"status\":\"PASS\",\"formatter\":\"bounded\"}");
    return 0;
}
