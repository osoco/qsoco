defmodule Test do
    def execute(script_in_docs_folder) do
        IO.puts("Executing script " <> script_in_docs_folder <> "...")
        case System.cmd("bash",[script_in_docs_folder], cd: "docs") do
            {output, 0} -> {:ok, output}
            {output, 1} -> {:error, output}
        end
    end
end

with {:ok, _} <- Test.execute("uninstall_odocker.sh"),
     {:ok, _} <- Test.execute("install_odocker"),
     {:ok, output} <- Test.execute(System.get_env("HOME")<>"/.odocker/bin/odocker.sh")
do
    case String.contains?(output, "") do
        true -> IO.puts("odocker ready!")
        false -> throw("Error: " <> output)
    end
else
    err -> throw(err)
end
