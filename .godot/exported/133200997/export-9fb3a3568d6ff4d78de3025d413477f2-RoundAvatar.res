RSRC                     ShaderMaterial            ��������                                            )      resource_local_to_scene    resource_name    output_port_for_preview    default_input_values    expanded_output_ports    source    texture    texture_type    script    code    graph_offset    mode    modes/blend    flags/skip_vertex_transform    flags/unshaded    flags/light_only    nodes/vertex/0/position    nodes/vertex/connections    nodes/fragment/0/position    nodes/fragment/3/node    nodes/fragment/3/position    nodes/fragment/4/node    nodes/fragment/4/position    nodes/fragment/connections    nodes/light/0/position    nodes/light/connections    nodes/start/0/position    nodes/start/connections    nodes/process/0/position    nodes/process/connections    nodes/collide/0/position    nodes/collide/connections    nodes/start_custom/0/position    nodes/start_custom/connections     nodes/process_custom/0/position !   nodes/process_custom/connections    nodes/sky/0/position    nodes/sky/connections    nodes/fog/0/position    nodes/fog/connections    shader    
   Texture2D :   res://addons/github-integration/resources/user/circle.png ��f���0   
   local://1 *      
   local://2 n      
   local://3 �         local://ShaderMaterial_xtwon �         VisualShaderNodeTexture                                   VisualShaderNodeTexture                      VisualShader 
   	      �   shader_type canvas_item;



void fragment() {
	vec4 n_out4p0;
// Texture2D:4
	n_out4p0 = texture(TEXTURE, UV);


// Output:0
	COLOR.rgb = vec3(n_out4p0.xyz);


}
 
   
   ����  C                                   
         HC               
         �B                                  ShaderMaterial    (                  RSRC