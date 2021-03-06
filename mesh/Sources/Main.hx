package;

import iron.App;
import iron.Scene;
import iron.RenderPath;
import iron.data.*;
import iron.data.SceneFormat;
import iron.object.Object;

class Main {

	static var raw:TSceneFormat;

	public static function main() {
		kha.System.init({title: "Empty", width: 960, height: 540, samplesPerPixel: 4}, function() {
			App.init(ready);
		});
	}

	static function ready() {
		var path = new RenderPath();
		path.commands = function() {
			path.setTarget("");
			path.clearTarget(0xff6495ED, 1.0);
			path.drawMeshes("mesh");
		};
		RenderPath.setActive(path);

		raw = {
			name: "Scene",
			shader_datas: [],
			material_datas: [],
			mesh_datas: [],
			objects: []
		}
		Data.cachedSceneRaws.set(raw.name, raw);
		Scene.create(raw, sceneReady);
	}

	static function sceneReady(scene:Object) {
		
		var sh:TShaderData = {
			name: "MyShader",
			contexts: [
				{
					name: "mesh",
					vertex_shader: "mesh.vert",
					fragment_shader: "mesh.frag",
					compare_mode: "less",
					cull_mode: "clockwise",
					depth_write: true,
					constants: [
						{ name: "color", type: "vec3" }
					],
					vertex_structure: [
						{ name: "pos", size: 3 }
					]
				}
			]
		}
		raw.shader_datas.push(sh);

		var col = new kha.arrays.Float32Array(3);
		col[0] = 1.0; col[1] = 0.0; col[2] = 0.0;

		var md:TMaterialData = {
			name: "MyMaterial",
			shader: "MyShader",
			contexts: [
				{
					name: "mesh",
					bind_constants: [
						{ name: "color", vec3: col }
					]
				}
			]
		}
		raw.material_datas.push(md);

		MaterialData.parse(raw.name, md.name, function(res:MaterialData) {
			dataReady();
		});
	}

	static function dataReady() {	
		var o:TObj = {
			name: "Suzanne",
			type: "mesh_object",
			data_ref: "Suzanne.arm/Suzanne",
			material_refs: ["MyMaterial"],
			transform: null
		}
		raw.objects.push(o);

		Scene.active.parseObject(raw.name, o.name, null, function(o:Object) {
			trace('Monkey ready');
		});
	}
}
