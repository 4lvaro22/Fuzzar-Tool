import type { DataType } from "../types/dataType"

export async function getData(): Promise<DataType[]> {
    const data: DataType[] = await fetch(
      "./data.json"
    )
      .then(async (res) => {
        if (Math.floor(res.status / 100) === 2) {
          return res.json()
        }
  
        return null
      })
      .catch((err) => console.error(err));
  
    return data;
}