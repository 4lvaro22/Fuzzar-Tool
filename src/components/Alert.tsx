
interface Props {
    title: string;
    description: string;
}

export default function Alert(props: Props) {
    return (
        <div className="bg-blue-100 border-t-4 border-blue-500 rounded-b text-dark-900 ps-5 pe-10 py-3 shadow-md w-fit mx-5 z-10 absolute opacity-90 right-0" role="alert">
            <div className="flex">
                <div className="py-1">
                    <svg className="h-8 w-8 text-dark-500 mx-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
                <div>
                    <p className="font-bold">{props.title}</p>
                    <p className="text-sm">{props.description}</p>
                </div>
            </div>
        </div>
    )
}