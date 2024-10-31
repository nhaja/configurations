return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({})

		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
					attach_mappings = function(prompt_buffer_nr, map)
						map("i", _G["modifier_right"] .. "-r>", function()
							local selected_entry = require("telescope.actions.state").get_selected_entry()
							local current_picker =
								require("telescope.actions.state").get_current_picker(prompt_buffer_nr)
							harpoon:list():remove_at(selected_entry.index)
							current_picker:refresh(require("telescope.finders").new_table({
								results = harpoon:list(),
							}))
						end)

						return true
					end,
				})
				:find()
		end

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", _G["modifier_right"] .. "-f>", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window" })
	end,
}