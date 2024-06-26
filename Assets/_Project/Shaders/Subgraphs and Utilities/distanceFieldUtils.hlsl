﻿//UNITY_SHADER_NO_UPGRADE
#ifndef DISTANCEFIELDUTILS_INCLUDED
#define DISTANCEFIELDUTILS_INCLUDED

/*****************************************************************

import sys
import math

size = 10
w = size*2 + 1
offset = size

sys.stdout.write(f"static float distanceField[{w}][{w}] = {{\n")
for x in range(w):
    line=[]
    for y in range(w):
        d = math.sqrt(pow(x-offset, 2) + pow(y-offset, 2))
        line.append(f"{d: 8.4f}f")
    sys.stdout.write(f"    {{ {', '.join(line)} }},\n")
sys.stdout.write("};\n");

sys.stdout.write(f"""
float vectorLength(int i, int j)
{{
    const int x = i + {offset};
    const int y = j + {offset};

    if (x>={w} || y>={w}) return length(float2(i, j));
    return distanceField[x][y]; 
}}
""");

*****************************************************************/

static float distanceField[21][21] = {
    {  14.1421f,  13.4536f,  12.8062f,  12.2066f,  11.6619f,  11.1803f,  10.7703f,  10.4403f,  10.1980f,  10.0499f,  10.0000f,  10.0499f,  10.1980f,  10.4403f,  10.7703f,  11.1803f,  11.6619f,  12.2066f,  12.8062f,  13.4536f,  14.1421f },
    {  13.4536f,  12.7279f,  12.0416f,  11.4018f,  10.8167f,  10.2956f,   9.8489f,   9.4868f,   9.2195f,   9.0554f,   9.0000f,   9.0554f,   9.2195f,   9.4868f,   9.8489f,  10.2956f,  10.8167f,  11.4018f,  12.0416f,  12.7279f,  13.4536f },
    {  12.8062f,  12.0416f,  11.3137f,  10.6301f,  10.0000f,   9.4340f,   8.9443f,   8.5440f,   8.2462f,   8.0623f,   8.0000f,   8.0623f,   8.2462f,   8.5440f,   8.9443f,   9.4340f,  10.0000f,  10.6301f,  11.3137f,  12.0416f,  12.8062f },
    {  12.2066f,  11.4018f,  10.6301f,   9.8995f,   9.2195f,   8.6023f,   8.0623f,   7.6158f,   7.2801f,   7.0711f,   7.0000f,   7.0711f,   7.2801f,   7.6158f,   8.0623f,   8.6023f,   9.2195f,   9.8995f,  10.6301f,  11.4018f,  12.2066f },
    {  11.6619f,  10.8167f,  10.0000f,   9.2195f,   8.4853f,   7.8102f,   7.2111f,   6.7082f,   6.3246f,   6.0828f,   6.0000f,   6.0828f,   6.3246f,   6.7082f,   7.2111f,   7.8102f,   8.4853f,   9.2195f,  10.0000f,  10.8167f,  11.6619f },
    {  11.1803f,  10.2956f,   9.4340f,   8.6023f,   7.8102f,   7.0711f,   6.4031f,   5.8310f,   5.3852f,   5.0990f,   5.0000f,   5.0990f,   5.3852f,   5.8310f,   6.4031f,   7.0711f,   7.8102f,   8.6023f,   9.4340f,  10.2956f,  11.1803f },
    {  10.7703f,   9.8489f,   8.9443f,   8.0623f,   7.2111f,   6.4031f,   5.6569f,   5.0000f,   4.4721f,   4.1231f,   4.0000f,   4.1231f,   4.4721f,   5.0000f,   5.6569f,   6.4031f,   7.2111f,   8.0623f,   8.9443f,   9.8489f,  10.7703f },
    {  10.4403f,   9.4868f,   8.5440f,   7.6158f,   6.7082f,   5.8310f,   5.0000f,   4.2426f,   3.6056f,   3.1623f,   3.0000f,   3.1623f,   3.6056f,   4.2426f,   5.0000f,   5.8310f,   6.7082f,   7.6158f,   8.5440f,   9.4868f,  10.4403f },
    {  10.1980f,   9.2195f,   8.2462f,   7.2801f,   6.3246f,   5.3852f,   4.4721f,   3.6056f,   2.8284f,   2.2361f,   2.0000f,   2.2361f,   2.8284f,   3.6056f,   4.4721f,   5.3852f,   6.3246f,   7.2801f,   8.2462f,   9.2195f,  10.1980f },
    {  10.0499f,   9.0554f,   8.0623f,   7.0711f,   6.0828f,   5.0990f,   4.1231f,   3.1623f,   2.2361f,   1.4142f,   1.0000f,   1.4142f,   2.2361f,   3.1623f,   4.1231f,   5.0990f,   6.0828f,   7.0711f,   8.0623f,   9.0554f,  10.0499f },
    {  10.0000f,   9.0000f,   8.0000f,   7.0000f,   6.0000f,   5.0000f,   4.0000f,   3.0000f,   2.0000f,   1.0000f,   0.0000f,   1.0000f,   2.0000f,   3.0000f,   4.0000f,   5.0000f,   6.0000f,   7.0000f,   8.0000f,   9.0000f,  10.0000f },
    {  10.0499f,   9.0554f,   8.0623f,   7.0711f,   6.0828f,   5.0990f,   4.1231f,   3.1623f,   2.2361f,   1.4142f,   1.0000f,   1.4142f,   2.2361f,   3.1623f,   4.1231f,   5.0990f,   6.0828f,   7.0711f,   8.0623f,   9.0554f,  10.0499f },
    {  10.1980f,   9.2195f,   8.2462f,   7.2801f,   6.3246f,   5.3852f,   4.4721f,   3.6056f,   2.8284f,   2.2361f,   2.0000f,   2.2361f,   2.8284f,   3.6056f,   4.4721f,   5.3852f,   6.3246f,   7.2801f,   8.2462f,   9.2195f,  10.1980f },
    {  10.4403f,   9.4868f,   8.5440f,   7.6158f,   6.7082f,   5.8310f,   5.0000f,   4.2426f,   3.6056f,   3.1623f,   3.0000f,   3.1623f,   3.6056f,   4.2426f,   5.0000f,   5.8310f,   6.7082f,   7.6158f,   8.5440f,   9.4868f,  10.4403f },
    {  10.7703f,   9.8489f,   8.9443f,   8.0623f,   7.2111f,   6.4031f,   5.6569f,   5.0000f,   4.4721f,   4.1231f,   4.0000f,   4.1231f,   4.4721f,   5.0000f,   5.6569f,   6.4031f,   7.2111f,   8.0623f,   8.9443f,   9.8489f,  10.7703f },
    {  11.1803f,  10.2956f,   9.4340f,   8.6023f,   7.8102f,   7.0711f,   6.4031f,   5.8310f,   5.3852f,   5.0990f,   5.0000f,   5.0990f,   5.3852f,   5.8310f,   6.4031f,   7.0711f,   7.8102f,   8.6023f,   9.4340f,  10.2956f,  11.1803f },
    {  11.6619f,  10.8167f,  10.0000f,   9.2195f,   8.4853f,   7.8102f,   7.2111f,   6.7082f,   6.3246f,   6.0828f,   6.0000f,   6.0828f,   6.3246f,   6.7082f,   7.2111f,   7.8102f,   8.4853f,   9.2195f,  10.0000f,  10.8167f,  11.6619f },
    {  12.2066f,  11.4018f,  10.6301f,   9.8995f,   9.2195f,   8.6023f,   8.0623f,   7.6158f,   7.2801f,   7.0711f,   7.0000f,   7.0711f,   7.2801f,   7.6158f,   8.0623f,   8.6023f,   9.2195f,   9.8995f,  10.6301f,  11.4018f,  12.2066f },
    {  12.8062f,  12.0416f,  11.3137f,  10.6301f,  10.0000f,   9.4340f,   8.9443f,   8.5440f,   8.2462f,   8.0623f,   8.0000f,   8.0623f,   8.2462f,   8.5440f,   8.9443f,   9.4340f,  10.0000f,  10.6301f,  11.3137f,  12.0416f,  12.8062f },
    {  13.4536f,  12.7279f,  12.0416f,  11.4018f,  10.8167f,  10.2956f,   9.8489f,   9.4868f,   9.2195f,   9.0554f,   9.0000f,   9.0554f,   9.2195f,   9.4868f,   9.8489f,  10.2956f,  10.8167f,  11.4018f,  12.0416f,  12.7279f,  13.4536f },
    {  14.1421f,  13.4536f,  12.8062f,  12.2066f,  11.6619f,  11.1803f,  10.7703f,  10.4403f,  10.1980f,  10.0499f,  10.0000f,  10.0499f,  10.1980f,  10.4403f,  10.7703f,  11.1803f,  11.6619f,  12.2066f,  12.8062f,  13.4536f,  14.1421f },
};

float vectorLength(int i, int j)
{
    const int x = i + 10;
    const int y = j + 10;

    if (x>=21 || y>=21) return length(float2(i, j));
    return distanceField[x][y]; 
}

#endif // DISTANCEFIELDUTILS_INCLUDED
