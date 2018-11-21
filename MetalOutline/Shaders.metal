
#include <metal_stdlib>
using namespace metal;

#include <SceneKit/scn_metal>

struct VertexIn {
    float3 position [[attribute(SCNVertexSemanticPosition)]];
    float3 normal   [[attribute(SCNVertexSemanticNormal)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float3 normal;
};

struct NodeConstants {
    float4x4 modelViewProjectionTransform;
    float4x4 normalTransform;
};

vertex VertexOut outline_vertex(VertexIn in                      [[stage_in]],
                                constant NodeConstants &scn_node [[buffer(1)]])
{
    float3 modelNormal = normalize(in.normal);
    float3 modelPosition = in.position;
    const float extrusionMagnitude = 0.05; // Ideally this would scale so as to be resolution and distance independent
    modelPosition += modelNormal * extrusionMagnitude;
    
    VertexOut out;
    out.position = scn_node.modelViewProjectionTransform * float4(modelPosition, 1);
    out.color = float4(1, 1, 0, 1);
    out.normal = (scn_node.normalTransform * float4(in.normal, 1)).xyz;
    return out;
}

fragment half4 outline_fragment(VertexOut in [[stage_in]]) {
    return half4(in.color);
}
