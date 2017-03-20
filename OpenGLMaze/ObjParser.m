//
//  ObjParser.m
//  OpenGLMaze
//
//  Created by Spencer Pollock on 2017-03-19.
//  Copyright © 2017 Einr. All rights reserved.
//

#import "ObjParser.h"

@implementation ObjParser
- (void)parseFile: (NSString *)_path _vertices:(GLfloat **)_vertices _normals:(GLfloat **)_normals _textures:(GLfloat **)_textures _indicies:(GLuint **)_indicies
   {
       NSArray *lineArray;
       int vcur = 0, ncur = 0, tcur = 0, icur = 0;
       NSMutableArray   *v = [[NSMutableArray alloc] init],
                        *n = [[NSMutableArray alloc] init],
                        *t = [[NSMutableArray alloc] init],
                        *i = [[NSMutableArray alloc] init];
       NSString *fileContents = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:NULL];
       for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
           if ([line hasPrefix:@"v "]) {
               lineArray = [line componentsSeparatedByString:@" "];
               [v addObject:lineArray[1]];
               [v addObject:lineArray[2]];
               [v addObject:lineArray[3]];
               vcur = vcur + 3;
           }
           if ([line hasPrefix:@"vn "]) {
               lineArray = [line componentsSeparatedByString:@" "];
               [n addObject:lineArray[1]];
               [n addObject:lineArray[2]];
               [n addObject:lineArray[3]];
               ncur = ncur + 3;
           }
           if ([line hasPrefix:@"vt "]) {
               lineArray = [line componentsSeparatedByString:@" "];
               [t addObject:lineArray[1]];
               [t addObject:lineArray[2]];
               [t addObject:lineArray[3]];
               tcur = tcur + 3;
           }
           if ([line hasPrefix:@"f "]) {
               lineArray = [line componentsSeparatedByString:@" "];
               for (int ff = 1; ff < lineArray.count; ff++) {
                   NSArray *temp = [lineArray[ff] componentsSeparatedByString:@"/"];
                   [i addObject:temp[0]];
                   [i addObject:temp[2]];
                   icur = icur + 2;
               }
           }
       }
       GLfloat **vglf = [self convertArraytoGLfloat:v];
       GLfloat **nglf = [self convertArraytoGLfloat:n];
       GLfloat **tglf = [self convertArraytoGLfloat:t];
       GLuint **igli = [self convertArraytoGLuint:i];
       [self copyGLfloat:*vglf to:_vertices count:vcur];
       [self copyGLfloat:*nglf to:_normals count:ncur];
       [self copyGLfloat:*tglf to:_textures count:tcur];
       [self copyGLuint:*igli to:_indicies count:icur];
   }
- (void)copyGLfloat: (GLfloat*)from to:(GLfloat **)to count:(int)count {
    *to = malloc(sizeof(GLfloat) * count);
    for(int i = 0; i < count; i++) {
        *to[i] = from[i];
    }
}
- (void)copyGLuint: (GLuint*)from to:(GLuint **)to count:(int)count {
    *to = malloc(sizeof(GLuint) * count);
    for(int i = 0; i < count; i++) {
        *to[i] = from[i];
    }
}
- (GLfloat **)convertArraytoGLfloat:(NSMutableArray *)ns {
    GLfloat *gl = malloc(sizeof(GLfloat) * [ns count]);
    for (int i = 0; i < [ns count]; i++) {
        gl[i] = (GLfloat) [[ns objectAtIndex:i] floatValue];
    }
    return &gl;
}
- (GLuint **)convertArraytoGLuint:(NSMutableArray *)ns {
    GLfloat *gl = malloc(sizeof(GLuint) * [ns count]);
    for (int i = 0; i < [ns count]; i++) {
        gl[i] = (GLuint) [[ns objectAtIndex:i] floatValue];
    }
    return &gl;
}
@end
