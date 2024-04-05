import { useEffect, useState } from "react"
import type { DataType } from "../types/dataType"
import { getData } from "../service/getData"

export default function Table() {
    const backgroundFailed: string = "bg-red-100 border-red-200"
    const backgroundSuccess: string = "bg-green-100 border-green-200"
    const backgroundWarning: string = "bg-yellow-100 border-yellow-200"
    const [data, setData] = useState<DataType[]>([])

    useEffect(() => {
        const source = new EventSource('./data.json');
        source.onmessage = function (event) {
            console.log("danik")
            alert("hola")
        };

        const fetchData = async () => {
            const dataRecollected = await getData()
            setData(dataRecollected)
        };
        fetchData()
        
        return () => source.close(); // Cerrar conexión al desmontar componente
    }, []);




    return (
        <div className="sm:-mx-6 lg:-mx-8">
            <div className="py-2 inline-block min-w-full sm:px-6 lg:px-8">
                <div className="overflow-hidden">
                    <table className="min-w-full text-center">
                        <thead className="border-b">
                            <tr>
                                <th scope="col" className="text-sm font-medium text-gray-900 px-6 py-4">
                                    Fecha
                                </th>
                                <th scope="col" className="text-sm font-medium text-gray-900 px-6 py-4">
                                    Herramienta
                                </th>
                                <th scope="col" className="text-sm font-medium text-gray-900 px-6 py-4">
                                    Exploración de errores
                                </th>
                                <th scope="col" className="text-sm font-medium text-gray-900 px-6 py-4">
                                    Número de ejecuciones
                                </th>
                                <th scope="col" className="text-sm font-medium text-gray-900 px-6 py-4">
                                    Tiempo transcurrido
                                </th>
                                <th scope="col" className="text-sm font-medium text-gray-900 px-6 py-4">
                                    Errores encontrados
                                </th>
                                <th scope="col" className="text-sm font-medium text-gray-900 px-6 py-4">
                                    Timeouts encontrados
                                </th>
                                <th scope="col" className="text-sm font-medium text-gray-900 px-6 py-4">
                                    Estado
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            {
                                data.map(individualdata => (
                                    <tr className={"border-b " + (individualdata.saved_crashes <= 0 ? backgroundSuccess : backgroundFailed)}>
                                        <td className="text-sm text-gray-900 font-medium px-6 py-4 whitespace-nowrap">
                                            {individualdata.date}
                                        </td>
                                        <td className="text-sm text-gray-900 font-medium px-6 py-4 whitespace-nowrap">
                                            {individualdata.tool}
                                        </td>
                                        <td className="text-sm text-gray-900 font-medium px-6 py-4 whitespace-nowrap">
                                            {individualdata.sanitizer == "" ? "-" : individualdata.sanitizer}
                                        </td>
                                        <td className="text-sm text-gray-900 font-medium px-6 py-4 whitespace-nowrap">
                                            {individualdata.execs_done}
                                        </td>
                                        <td className="text-sm text-gray-900 font-medium px-6 py-4 whitespace-nowrap">
                                            {individualdata.time}
                                        </td>
                                        <td className="text-sm text-gray-900 font-medium px-6 py-4 whitespace-nowrap">
                                            {individualdata.saved_crashes}
                                        </td>
                                        <td className="text-sm text-gray-900 font-medium px-6 py-4 whitespace-nowrap">
                                            0
                                        </td>
                                        <td className="text-sm text-gray-900 font-medium px-6 py-4 whitespace-nowrap">
                                            {individualdata.saved_crashes == 0 ? "Superada" : "Fallada"}
                                        </td>
                                    </tr>
                                ))
                            }
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    )
}